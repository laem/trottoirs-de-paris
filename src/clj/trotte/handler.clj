(ns trotte.handler
  (:require [compojure.core :refer [GET defroutes]]
            [compojure.route :refer [not-found resources]]
            [ring.middleware.defaults :refer [site-defaults wrap-defaults]]
            [selmer.parser :refer [render-file]]
            [prone.middleware :refer [wrap-exceptions]]
            [environ.core :refer [env]]
            [monger.core :as mg]
            [monger.collection :as mc])
          (:import [com.mongodb MongoOptions ServerAddress]))

(defn tokoutoussek []
  (let [conn (mg/connect) db (mg/get-db conn "monger-test")]
    (mc/insert db "documents" { :first_name "Haha" :last_name "Lennon" })
    "Merci mon pote"))

(defroutes routes
  (GET "/" [] (render-file "templates/index.html" {:dev (env :dev?)}))
  (GET "/mongo" [] (tokoutoussek))
  (resources "/")
  (not-found "Not Found"))

(def app
  (let [handler (wrap-defaults routes site-defaults)]
    (if (env :dev?) (wrap-exceptions handler) handler)))
