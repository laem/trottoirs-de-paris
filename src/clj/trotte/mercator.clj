(ns trotte.mercator)
;; taken from https://github.com/dmitriiabramov/clojure-mercator-projection

(def PI (. Math PI))
(def rad-per-deg (/ PI 180.0))
(def equatorial-radius 6378137.0)

(defn mercator [long-lat]
  (let [[λ φ] long-lat
        x (* λ rad-per-deg equatorial-radius)
        y (* (Math/log (Math/tan (+ (/ PI 4) (* φ (/ rad-per-deg 2.0))))) equatorial-radius)]
   [x y]))

(defn inverted-mercator [x-y]
  (let [[x y] x-y
        λ (/ x (* equatorial-radius rad-per-deg))
        φ (/ (- (* 2 (Math/atan (Math/exp (/ y equatorial-radius)))) (/ PI 2)) rad-per-deg)]
   [λ φ]))


(inverted-mercator (mercator [2.378934357368756 48.8457372123706]))
(mercator [2.378934357368756 48.8457372123706])
