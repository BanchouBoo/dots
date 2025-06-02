(local api {})

(fn spaceless-label [label]
  (label:gsub " " "."))

(fn labels-to-string [labels]
  (each [i label (ipairs labels)]
    (tset labels i (spaceless-label label)))
  (table.concat labels " "))

(fn string-to-labels [str]
  (var result [])
  (each [token (str:gmatch "([^ ]+)")]
    (tset result (+ (length result) 1) token))
  result)

(fn api.get-labels [client]
  (string-to-labels (client:get_xproperty :AWM_LABELS)))

(fn api.set-labels [client labels]
  (client:set_xproperty :AWM_LABELS (labels-to-string labels)))

(fn api.add-labels [client labels]
  (var new-labels (labels.get-labels client))
  (each [_ label (ipairs)]
    (tset new-labels (+ (length new-labels) 1) label))
  (api.set-labels client new-labels))

(fn api.has-label [client label]
  (var result nil)
  (each [_ l (ipairs (api.get-labels client)) &until (= result true)]
    (when (= (spaceless-label label) l)
      (set result true))))

(fn api.has-all-labels [client labels]
  (var found-false false)
    (each [_ label (ipairs labels) &until found-false]
      (when (not (api.has-label client label))
        (set found-false true)))
    (not found-false))

(fn api.has-any-labels [client labels]
  (var found-true false)
    (each [_ label (ipairs labels) &until found-true]
      (when (api.has-label client label)
        (set found-true true)))
    found-true)

(fn api.clients-with-all-labels [labels]
  (icollect [_ client (ipairs (client.get))]
    (when (api.has-all-labels client labels)
      client)))

(fn api.clients-with-any-labels [labels]
  (icollect [_ client (ipairs (client.get))]
    (when (api.has-any-labels client labels)
      client)))

(fn api.init []
  (awesome.register_xproperty :AWM_LABELS :string)
  (client.connect_signal
    "request::manage"
    #(api.set-labels $1 [])))

api
