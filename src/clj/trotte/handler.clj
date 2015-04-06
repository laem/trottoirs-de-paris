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
            [trotte.mercator :refer [mercator inverted-mercator]])
  (:import [com.mongodb MongoOptions ServerAddress]
    org.bson.types.ObjectId))

(def db (mg/get-db (mg/connect) "agreable"))

(def withinQuery { :geometry { $geoWithin
                             { "$geometry"
                               {
                                :type "Polygon"
                                :coordinates [[[2.3788082599639893 48.84600796705691]
                                               [2.3788082599639893 48.84652337993973]
                                               [2.3798999190330505 48.84652337993973]
                                               [2.3798999190330505 48.84600796705691]
                                               [2.3788082599639893 48.84600796705691]]]
                                } } } })



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
        k (/ d (Math/sqrt
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

;; TESTS START with this segment
(def seg [[2.379831219812292 48.845304455299846] [2.378934357368756 48.8457372123706]])
(def seg [ [ 2.364545590666204 48.870542444326375 ] [ 2.36458829896837 48.87056413432559 ]])

(defn drawPerps []
  (let [nearQuery { :geometry { $near
                             { "$geometry" {
                                :type "Point"
                                :coordinates [ 2.364621097806873, 48.87054776611247 ]
                                }
                               "$maxDistance" 10} } }
        results (mc/find-maps db "v" nearQuery)
        polygons (map (fn [{{coordinates :coordinates} :geometry}] coordinates) results)
        all-segments (mapcat
                   (fn [polygon]
                     (mapcat
                       (fn [ring]
                         (partition 2 1 ring))
                       polygon))
                   polygons)
        lonely-segments (dump-dups all-segments)]
    lonely-segments))

(def perp (compute-perp seg 50))
(def lineString (perp-lineString perp))

;perform an aggregation of $geoNear (to get the document distances) and $geoIntersects at the same time
(def caught (mc/aggregate db "t" [
   {
     "$geoNear" {
        :near {:type "Point" :coordinates (first perp)}
        :spherical true
        :maxDistance 50
        :distanceField "calculated_distance"
        :query { :geometry { "$geoIntersects" { "$geometry" (:geometry lineString) } }}
    }}
]))

;; Is it a trottoir ?
(contains? #{"BOR" "BTT"} (get-in (first caught) [:properties :info]))
; YEAH !!
(:calculated_distance (first caught))















(defn objectId-reader [key value]
  (if (= key :_id)
    (str value)
    value))

(defn getSample []
  (let [res (mc/find-maps db "v" nearQuery)]
    (json/write-str (nth res 2) :value-fn objectId-reader))
  )

(defn sample []
  (str (json/write-str (perp-lineString (compute-perp seg 50))))
)


;; ROUTES
(defroutes routes
  (GET "/" [] (render-file "templates/index.html" {:dev (env :dev?)}))
  (GET "/sample" [] (pr-str (drawPerps))) ;;
  (resources "/")
  (not-found "Not Found"))

;;APP
(def app
  (let [handler (wrap-defaults routes site-defaults)]
    (if (env :dev?) (wrap-exceptions handler) handler)))
