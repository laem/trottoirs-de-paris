(ns trotte.handler
  (:use clojure.core.matrix)
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
            [geo.spatial :as spatial])
  (:import [com.mongodb MongoOptions ServerAddress]))

(set-current-implementation :vectorz)

(def M (matrix [[1 2] [3 4]]))

(def v (matrix [1 2]))

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

(def nearQuery { :geometry { $near
                             { "$geometry" {
                                :type "Point"
                                :coordinates [2.3788082599639893 48.84600796705691]
                                }
                               "$maxDistance" 10} } })

(def seg [[2.379831219812292 48.845304455299846] [2.378934357368756 48.8457372123706]])

(defn divide [a b] (double (/ a b)))

(def radius-earth-paris 6366057)

;; x = R * cos(lat) * cos(lon)
;; y = R * cos(lat) * sin(lon)
(defn latlong->cartesian [lat lon]
  (let [R radius-earth-paris
        x (* R (Math/cos lat) (Math/cos lon))
        y (* R (Math/cos lat) (Math/sin lon))]
    [x y]))

;; lat = asin(z / R)
;; lon = atan2(y, x)
;;(defn cartesian->latlong [x y]
;;  [(Math/asin (divide radius-earth-paris ]
;;  )

(defn compute-perp [segment d]
  (let [[[ax ay] [bx by]] segment
        k (divide d (Math/sqrt
                  (+
                   (Math/pow (- bx ax) 2)
                   (Math/pow (- by ay) 2))))
        px (+ (* k (- ay by)) (divide (+ ax bx) 2))
        py (+ (* k (- ax bx)) (divide (+ ay by) 2))]

    (apply str [px ", " py])))




(defn objectId-reader [key value]
  (if (= key :_id)
    (str value)
    value))

(defn getSample []
  (let [res (mc/find-maps db "v" nearQuery)]
    (json/write-str (nth res 2) :value-fn objectId-reader))
  )



;; ROUTES
(defroutes routes
  (GET "/" [] (render-file "templates/index.html" {:dev (env :dev?)}))
  (GET "/sample" [] (str (spatial/earth-radius (spatial/geohash-point 48.84600796705691 2.3788082599639893)))) ;;(compute-perp seg 0.001)
  (resources "/")
  (not-found "Not Found"))

;;APP
(def app
  (let [handler (wrap-defaults routes site-defaults)]
    (if (env :dev?) (wrap-exceptions handler) handler)))
