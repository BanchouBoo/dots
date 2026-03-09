(local awful (require :awful))
(local ruled (require :ruled))
(local naughty (require :naughty))
(local labels (require :labels))

(ruled.client.connect_signal
  "request::rules"
  (fn []
    (ruled.client.append_rule
      {:id "global"
       :rule {}
       :properties
         {:focus awful.client.focus.filter
          :raise true
          :screen awful.screen.preferred
          :placement (+ awful.placement.centered awful.placement.no_offscreen)}})
    (ruled.client.append_rule
      {:id "Tag 1"
       :rule_any {:class ["Lutris" "steam"]}
       :properties {:tag :1}}
       :callback #(labels.set-labels $1 ["gaming"]))
    (ruled.client.append_rule
      {:id "Tag 3"
       :rule_any {:class ["chatterino"]}
       :properties {:tag :3}})
    (ruled.client.append_rule
      {:id "Tag 4"
       :rule_any {:class ["Anki" "RSS Guard"]}
       :properties {:tag :4}})
    (ruled.client.append_rule
      {:id "Tag 5"
       :rule_any {:class ["discord" "vesktop"]}
       :properties {:tag :5}})
    (ruled.client.append_rule
      {:id "Tag 6"
       :rule_any {:class ["Plover"]}
       :properties {:tag :6}})
    (ruled.client.append_rule
      {:id "Tag 9"
       :rule_any {:class ["qBittorrent"]}
       :properties {:tag :9}})
    (ruled.client.append_rule
      {:id "Anki"
       :rule_any {:class ["Anki"]}
       :except_any {:name ["^User.*Anki$"]}
       :properties {:floating true}})
    (ruled.client.append_rule
      {:id "Dragon"
       :rule_any {:class ["Dragon"]}
       :properties {:ontop true}})
    ))

(ruled.notification.connect_signal
  "request::rules"
  (fn []
    (ruled.notification.append_rule
      {:rule {}
       :properties
         {:screen awful.screen.preferred
          :implicit_timeout 5}})))

(naughty.connect_signal
  "request::display"
  (fn [notif]
    (naughty.layout.box {:notification notif})))
