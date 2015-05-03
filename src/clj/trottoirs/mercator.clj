(ns trottoirs.mercator)
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

(defn to-real-distance [φ d]
  (* d (Math/cos ( * φ rad-per-deg))))

(defn to-mercator-distance [φ d]
  (/ d (Math/cos ( * φ rad-per-deg))))

;; compute approximate length of a short segment (distance between its too points)
(defn segment-length [segment]
  (let [[[ax ay] [bx by]] (map #(mercator %1) segment)
        φ (second (first segment))
        mercator-distance (Math/sqrt (+ (Math/pow (- bx ax) 2) (Math/pow (- by ay) 2)))]
    (to-real-distance φ mercator-distance)
    ))

;; approximately 59
(segment-length [[2.378250360488891 48.84622684166889] [2.3790442943573 48.84632215773317]])
