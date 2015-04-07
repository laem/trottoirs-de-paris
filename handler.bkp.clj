(comment

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

(mc/remove-by-id db "t" (str segOid "-perp"))
  ;insert the perp in the collection
(mc/insert db "t" (assoc
                      lineString
                      :_id (str segOid "-perp")))


(def intersecting
  (mc/find-maps db "t" { :geometry { $geoIntersects { "$geometry" (:geometry lineString) } } }))

intersecting
(first perp)
(def not-far
  (let [raw-result (mg/command db (sorted-map :geoNear "t"
                             :near {:type "Point" :coordinates (first perp)}
                             :spherical true
                             :maxDistance 50))
        result (from-db-object raw-result true)]
    (:results result)))

(def ranking (map (fn [{:keys [dis obj]}] [dis (:_id obj)]) not-far))

(count ranking)

  )
