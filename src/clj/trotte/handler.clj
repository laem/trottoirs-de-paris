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
            [monger.operators :refer :all])
          (:import [com.mongodb MongoOptions ServerAddress]))

(def query { :geometry     { $geoWithin
                    { "$geometry"
                      {
                        :type "Polygon"
                        :coordinates [
                          [
                            [
                              2.3788082599639893
                              48.84600796705691
                            ]
                            [
                              2.3788082599639893
                              48.84652337993973
                            ]
                            [
                              2.3798999190330505
                              48.84652337993973
                            ]
                            [
                              2.3798999190330505
                              48.84600796705691
                            ]
                            [
                              2.3788082599639893
                              48.84600796705691
                            ]
                          ]
                        ]
      } } } })

(defn objectId-reader [key value]
  (if (= key :_id)
    (str value)
    value))

(defn tokoutoussek []
  (let [conn (mg/connect) db (mg/get-db conn "agreable") coll "trottoirs"]
    (str (mc/count db coll))
    (json/write-str (mc/find-maps db coll query) :value-fn objectId-reader)
    ))

(defroutes routes
  (GET "/" [] (render-file "templates/index.html" {:dev (env :dev?)}))
  (GET "/mongo" [] (tokoutoussek))
  (resources "/")
  (not-found "Not Found"))

(def app
  (let [handler (wrap-defaults routes site-defaults)]
    (if (env :dev?) (wrap-exceptions handler) handler)))
