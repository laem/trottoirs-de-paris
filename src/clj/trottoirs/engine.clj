(ns trottoirs.engine
 (:require  [monger.core :as mg]
            [clojure.data.json :as json]
            [monger.collection :as mc]
            [monger.operators :refer :all]
            [monger.conversion :refer [from-db-object]]
            [trottoirs.mercator :refer [mercator inverted-mercator segment-length to-mercator-distance]] 

   ))


;;; DB ;;;;;;;;;;;
(def db (mg/get-db (mg/connect) "agreable"))
(defn objectId-reader [key value]
  (if (= key :_id)
    (str value)
    value))


;;; Utils ;;;;;;;;;;;

(defn compute-perp [segment distance]
  "Compute the middle-perpendicular of length d of a long-lat segment"
;; We use the mercator projection to work on shapes with cartesian coordinates.
;; Another approach is to convert the coordinates to the cartesian earth system,
;;  then rotate it until the z axis crosses Paris.
;;  Use vectorz-clj and http://stackoverflow.com/a/1185413 with a conversion matrix
  (let [[A B] segment
        [ax ay] (mercator A)
        [bx by] (mercator B)
        [mx my :as M] [(/ (+ ax bx) 2) (/ (+ ay by) 2)]
        point-on-perp (fn [d] (let [mercator-d (to-mercator-distance (second A) d)
                                    k (/ mercator-d (Math/sqrt
                                              (+
                                               (Math/pow (- bx ax) 2)
                                               (Math/pow (- by ay) 2))))
                                    px (+ (* k (- ay by)) mx)
                                    py (+ (* k (- bx ax)) my)]
                               [px py]))
        m (inverted-mercator (point-on-perp 0.1)) ; a litte shift to avoid a perpendicular to overlap its origin segment
        p (inverted-mercator (point-on-perp distance))]

    [m p]))


(defn compute-perp-polygon [[A B] [M P]]
  (let [[ax ay] (mercator A)
        [bx by] (mercator B)
        [mx my] (mercator M)
        [px py] (mercator P)
        mpx (- px mx)
        mpy (- py my)
        C (inverted-mercator [(+ bx mpx) (+ by mpy)])
        D (inverted-mercator [(+ ax mpx) (+ ay mpy)])]
    [
      [A B C D A]
      ]))

(def mseg [[2.379831219812292 48.845304455299846] [2.378934357368756 48.8457372123706]])
(def mperp [[2.379382788590524 48.84552083430268] [2.3791172006642896 48.84528245774338]])
(compute-perp-polygon mseg mperp)

(defn geo-feature [geo-type coordinates properties]
  "Form the perpendicular geojson map"
  { :type "Feature"
    :properties (merge properties {:computed true}) ;not part of the real source of features
    :geometry { :type geo-type
                :coordinates coordinates}})

(defn dump-dups [seq]
  (for [[group els] (group-by :coords seq)
        :when (= (count els) 1)]
   (first els)))


;; perform a mongodb aggregation of $geoNear (just to get the document distances, increasing) and $geoIntersects
;; on the two collections
;; take the closest result of two requests, since shapes were separated in two collections
(defn closest-shape [perp id radius]
  (let [ q (fn [coll]
             (mc/aggregate
              db
              coll
              [{
                "$geoNear" {
                            :near {:type "Point" :coordinates (first perp)}
                            :spherical true
                            :maxDistance radius
                            :distanceField "calculated_distance"
                            :query { :geometry { "$geoIntersects" { "$geometry" (:geometry (geo-feature "LineString" perp nil)) } }}
                            }}]))
         [v-results t-results] (map q ["v" "t"]) ;; buildings (v) and trottoirs (t) collections
         ;;yop (do (println (str id ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")) (println v-results))
         ;; a polygon segment can intersect the polygon itself (because of decimal shifts probably), remove this result
         buildings (remove (fn [v] (and (= (:_id v) id) (< (:calculated_distance v) 0.5 ))) v-results)
         buildings v-results
         ;; ignore all types of trottoirs expect BORdures
         bordures (filter (fn [t] (= "BOR" (get-in t [:properties :info]))) t-results)] 
    (apply min-key
           #(if (nil? %) 10000 ;; this because I don't know how to code
             (:calculated_distance %))
           (map first [buildings bordures]))
    ))


;;; Main function ;;;;;;;;;;;
(defn draw-perps 
  ( [] (draw-perps nil nil nil)) ; that's ugly yeah
  ( [lat lng rad]
  (let [;; trottoirs will be computed around this central point with a given diameter
        nearQuery (if (every? some? [lat lng rad]) 
                    { :geometry 
                      { $near
                             { "$geometry" {
                                :type "Point"
                                ;; Grands boulevards
                                ;;:coordinates [2.3449641466140747 48.87105583726818] 
                                ;; Diderot
                                ;;:coordinates [2.378979921340942 48.84630097640122] 
                                ;; Adele
                                :coordinates [(read-string lng) (read-string lat)]}
                               "$maxDistance" (read-string rad) ;; diameter
                               } } } 
                    nil)
        ;; perform the query, will return building shapes
        results (mc/find-maps db "v" nearQuery)
        ;; get their coordinates
        polygons (map (fn [{id :_id {coordinates :coordinates} :geometry}] {:coords coordinates :id id}) results)
        ;; collect all the polygon segments
        all-segments (mapcat
                       (fn [{:keys [id coords]}]
                         (mapcat
                           (fn [ring]
                             (map #(assoc {:_id id} :coords %) (partition 2 1 ring)))
                           [(first coords)])) ;; don't take internal rings into account, if they happen to exist
                       polygons)
        ;; remove shared (duplicate) segments, since they can't be near a trottoir
        lonely-segments (dump-dups all-segments)
        ;; remove short segments, they usually are corners of buildings. This is a problem with round or complex structures TODO
        filtered-segments (filter (fn [seg] (> (segment-length (:coords seg)) 5)) lonely-segments)
        ;; compute [origin-segment corresponding-perpendicular-segment]
        perps (map (fn [seg] [seg (compute-perp (:coords seg) 20)]) filtered-segments)
        ;; check whether this perpendicular's first intersection is a bordure trottoir
        hits (mapcat (fn [[seg perp]]
                       (let [closest (closest-shape perp (:_id seg) 60)
                             valid (= "BOR" (get-in closest [:properties :info]))]
                         (if valid
                           (let [seg-coords (:coords seg)
                                 d-perp (compute-perp (:coords seg) (:calculated_distance closest))]
                             [{
                               :coordinates (compute-perp-polygon seg-coords d-perp)
                               :properties {:t-width (segment-length d-perp) }
                               }])
                           [])
                         ))
                  perps)
        ]
    ;;(json/write-str (map (comp geo-feature second) perps) :value-fn objectId-reader)
    ;;(json/write-str (remove nil? hits) :value-fn objectId-reader)
    ;;(json/write-str filtered-segments :value-fn objectId-reader)
    (let [out (str "{ \"type\": \"FeatureCollection\",\"features\": "
         (json/write-str (map #(geo-feature "Polygon" (:coordinates %) (:properties %)) hits) :value-fn objectId-reader)
         "}")]
      (do (spit "./trottoirs.geojson" out) (println "Outpout written in ./trottoirs.geojson"))
      out
      )

    )))

