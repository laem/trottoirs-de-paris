(ns trottoirs.core
    (:require [reagent.core :as reagent :refer [atom]]
              [reagent.session :as session]
              [secretary.core :as secretary :include-macros true]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [cljsjs.react :as react]
              [cljsjs.leaflet :as leaflet]
              [ajax.core :refer [GET POST]]
              [cognitect.transit :as t]
              )
    (:import goog.History))

;; -------------------------
;; Views


(defn home-did-mount [[lat lng] radius]
  (let [map (.setView (.map js/L "map") #js [lat lng] 18)
        token "sk.eyJ1IjoibGFlbSIsImEiOiIxOURTMEtvIn0._LB5HO5XkDMWbWU4eu8RZg"
        r (t/reader :json)
        getHandler (fn [response] (.addTo (.geoJson js/L
                                                    (clj->js (t/read r response))
                                                    (clj->js {:style {:fillOpacity .25
                                                                      :color "green"
                                                                      :weight 0
                                                                      :stroke-width "2px"
                                                                      :stroke "red"}}))
                                          map))]
    (do
      (identity (.addTo (.tileLayer js/L (str "http://{s}.tiles.mapbox.com/v4/laem.lihjhd1m/{z}/{x}/{y}.png?access_token=" token)
                        (clj->js {:attribution "Thks, mapbox"
                                  :maxZoom 19}))
            map))
      (GET (str "/features/" lat "/" lng "/" radius ) {:handler getHandler}))))


(defn home-render []
  [:div [:h2 "Bienvenue"]
    [:div#map ]
    [:div [:a {:href "#/about"} "go to about page"]]])

(defn home [epicenter radius]
  (reagent/create-class {:reagent-render home-render
                         :component-did-mount (partial home-did-mount epicenter radius)}))


(defn about-page []
  [:div [:h2 "About trottoirs"]
   [:div [:a {:href "#/"} "go to the home page"]]])

(defn current-page []
  [:div [(session/get :current-page)]])

;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/t/:lat/:lng/:rad" {:as params}
  (session/put! :current-page (#'home [(:lat params) (:lng params)] (:rad params))))

(secretary/defroute "/about" []
  (session/put! :current-page #'about-page))

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -------------------------
;; Initialize app
(defn mount-root []
  (reagent/render [current-page] (.getElementById js/document "app")))

(defn init! []
  (hook-browser-navigation!)
  (mount-root))
