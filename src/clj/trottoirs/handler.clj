(ns trottoirs.handler
  (:require [compojure.core :refer [GET defroutes]]
            [compojure.route :refer [not-found resources]]
            [ring.middleware.defaults :refer [site-defaults wrap-defaults]]
            [clojure.data.json :as json]
            [selmer.parser :refer [render-file]]
            [prone.middleware :refer [wrap-exceptions]]
            [environ.core :refer [env]]
            [trottoirs.engine :refer [draw-perps get-features]]
            )
  )


;; ROUTES
(defroutes routes
  (GET "/" [] (render-file "templates/index.html" {:dev (env :dev?)}))
  (GET "/sample/:lat/:lng/:rad" [lat lng rad] (draw-perps lat lng rad)) ;;
  (GET "/features/:lat/:lng/:rad" [lat lng rad] (draw-perps lat lng rad))
  (resources "/")
  (not-found "Not Found"))

;;APP
(def app
  (let [handler (wrap-defaults routes site-defaults)]
    (if (env :dev?) (wrap-exceptions handler) handler)))
