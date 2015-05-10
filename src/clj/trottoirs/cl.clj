(ns trottoirs.cl
   (:require [clojure.tools.cli :refer [parse-opts]]
             [trottoirs.engine :refer [draw-perps]]
             )
  (:gen-class))


(defn -main [& args]
  (let [cli-options [           ["-h" "--help" "Print this help"
                                 :default false :flag true]
                                ["-a" "--latitude LATITUDE" ]
                                ["-o" "--longitude LONGITUDE" ]
                                ["-r" "--radius RADIUS" ]
                                ]
       {:keys [options summary] } (parse-opts args cli-options)]
    (if (:help options)
      (println summary "\n Do not specify any option to query everything")
      (if (:radius options)
        (draw-perps (:latitude options) (:longitude options) (:radius options))
        (draw-perps)))
    ))
