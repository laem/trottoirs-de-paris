(def polygons
[[
  [
    [1 11]
    [2 22]
    [3 33]
    [4 44]
  ]
]
 [
  [
    [9 99]
    [10 1010]
    [11 1111]
    [2 22]
    [3 33]
    [12 1212]
  ]
]])

(def res (mapcat
 (fn [polygon]
   (mapcat
     (fn [ring]
       (partition 2 1 ring))
     polygon))
 polygons))
res

(defn dump-dups [seq]
  (for [[id freq] (frequencies seq)  ;; get the frequencies, destructure
        :when (= freq 1)]            ;; this is the filter condition
   id))

(dump-dups res)
