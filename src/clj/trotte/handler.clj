(ns trotte.handler
  (:require [compojure.core :refer [GET defroutes]]
            [compojure.route :refer [not-found resources]]
            [ring.middleware.defaults :refer [site-defaults wrap-defaults]]
            [clojure.data.json :as json]
            [selmer.parser :refer [render-file]]
            [prone.middleware :refer [wrap-exceptions]]
            [environ.core :refer [env]]
            [monger.core :as mg]
            [monger.collection :as mc]
            [monger.operators :refer :all]
            [monger.conversion :refer [from-db-object]]
            [trotte.mercator :refer [mercator inverted-mercator segment-length to-mercator-distance]])
  (:import [com.mongodb MongoOptions ServerAddress]
    org.bson.types.ObjectId))

;;; DB ;;;;;;;;;;;
(def db (mg/get-db (mg/connect) "agreable"))
(defn objectId-reader [key value]
  (if (= key :_id)
    (str value)
    value))



;;; Utils ;;;;;;;;;;;

(defn compute-perp [segment d]
  "Compute the middle-perpendicular of a segment seg of length d"
;;We use the mercator projection to work on shapes with cartesian coordinates.
;;Another approach is to convert the coordinates to the cartesian earth system,
;;  then rotate it until the z axis crosses Paris.
;;  Use vectorz-clj and http://stackoverflow.com/a/1185413 with a conversion matrix
  (let [[A B] segment
        [ax ay] (mercator A)
        [bx by] (mercator B)
        [mx my :as M] [(/ (+ ax bx) 2) (/ (+ ay by) 2)]
        mercator-d (to-mercator-distance (second A) d)
        k (/ mercator-d (Math/sqrt
                  (+
                   (Math/pow (- bx ax) 2)
                   (Math/pow (- by ay) 2))))
        px (+ (* k (- ay by)) mx)
        py (+ (* k (- bx ax)) my)
        m (inverted-mercator [mx my])
        p (inverted-mercator [px py])]

    [m p]))

(defn perp-lineString [coordinates]
  "Form the perpendicular geojson map"
  { :type "Feature"
    :properties {:computed true} ;not part of the real source of features
    :geometry { :type "LineString"
                :coordinates coordinates}})

(defn dump-dups [seq]
  (for [[id freq] (frequencies seq)  ;; get the frequencies, destructure
        :when (= freq 1)]            ;; this is the filter condition
   id))

;; perform a mongodb aggregation of $geoNear (just to get the document distances, increasing) and $geoIntersects
;; take the closest result of two requests, since shapes were separated in two collections
(defn closest-shape [perp radius]
  (let [ q
         (fn [coll]
           (mc/aggregate
            db
            coll
            [{
              "$geoNear" {
                          :near {:type "Point" :coordinates (first perp)}
                          :spherical true
                          :maxDistance radius
                          :distanceField "calculated_distance"
                          :query { :geometry { "$geoIntersects" { "$geometry" (:geometry (perp-lineString perp)) } }}
                          }}]))]
    (apply min-key #(if (nil? %) 10000 (:calculated_distance %)) (map (comp first q) ["t" "v"]))
    ))

(apply min-key identity (remove nil? [ nil 1]))

;;; Main function ;;;;;;;;;;;
(defn drawPerps []
  (let [nearQuery { :geometry { $near
                             { "$geometry" {
                                :type "Point"
                                :coordinates [2.3795807361602783 48.84644395021793]
                                }
                               "$maxDistance" 100} } }
        ;; get some bati geojson
        results (mc/find-maps db "v" nearQuery)
        ;; get their coordinates
        polygons (map (fn [{{coordinates :coordinates} :geometry}] coordinates) results)
        ;; collect all the polygon segments
        all-segments (mapcat
                       (fn [polygon]
                         (mapcat
                           (fn [ring]
                             (partition 2 1 ring))
                           polygon))
                       polygons)
        ;; remove shared (duplicate) segments, since they can't be near a trottoir
        lonely-segments (dump-dups all-segments)
        ;; remove short segments, they usually are corners of bati. This is a problem with round structures TODO
        filtered-segments (filter (fn [s] (> (segment-length s) 5)) lonely-segments)
        ;; compute perpendicular segments
        perps (map (fn [lseg] [lseg (compute-perp lseg 20)]) filtered-segments)
        ;; check whether this perpendicular's first intersection is a bordure trottoir
        hits (mapcat (fn [[lseg perp]]
                       (let [closest (closest-shape perp 60)
                             valid (= "BOR" (get-in closest [:properties :info]))]
                         [valid]
                         (if valid [(compute-perp lseg (:calculated_distance closest))] [])
                         ))
                  perps)
        ]
    ;(json/write-str hits :value-fn objectId-reader)
    (json/write-str (map perp-lineString hits) :value-fn objectId-reader)
    ))



;; ROUTES
(defroutes routes
  (GET "/" [] (render-file "templates/index.html" {:dev (env :dev?)}))
  (GET "/sample" [] (drawPerps)) ;;
  (resources "/")
  (not-found "Not Found"))

;;APP
(def app
  (let [handler (wrap-defaults routes site-defaults)]
    (if (env :dev?) (wrap-exceptions handler) handler)))
