(ns trotte.core
    (:require [reagent.core :as reagent :refer [atom]]
              [reagent.session :as session]
              [secretary.core :as secretary :include-macros true]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [cljsjs.react :as react]
              [cljsjs.leaflet :as leaflet])
    (:import goog.History))

;; -------------------------
;; Views

(defn home-did-mount []
  (let [map (.setView (.map js/L "map") #js [48.846195 2.379443] 18)
        token "sk.eyJ1IjoibGFlbSIsImEiOiIxOURTMEtvIn0._LB5HO5XkDMWbWU4eu8RZg"]
    (.addTo (.tileLayer js/L (str "http://{s}.tiles.mapbox.com/v4/laem.lihjhd1m/{z}/{x}/{y}.png?access_token=" token)
                        (clj->js {:attribution "Map data &copy; [...]"
                                  :maxZoom 18}))
            map)))


(defn home []
  [:div [:h2 "Welcome to trotte"]
    [:div#map ]
    [:div [:a {:href "#/about"} "go to about page"]]])

(defn home-page []
  (reagent/create-class {:reagent-render home
                         :component-did-mount home-did-mount}))


(defn about-page []
  [:div [:h2 "About trotte"]
   [:div [:a {:href "#/"} "go to the home page"]]])

(defn current-page []
  [:div [(session/get :current-page)]])

;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (session/put! :current-page #'home-page))

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
