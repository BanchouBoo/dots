(local awful (require :awful))
(local naughty (require :naughty))
(local labels (require :labels))

(fn map-mods [mods]
  (let [modifiers {:ctrl "Control" :alt "Mod1" :shift "Shift" :super "Mod4"}]
    (icollect [_ mod (ipairs mods)]
      ; temporary or to make transition easier
      (or (. modifiers mod) mod))))

(fn key [mods ...]
  (awful.key (map-mods mods) ...))

(fn button [mods ...]
  (awful.button (map-mods mods) ...))

(awful.keyboard.append_global_keybindings
  [
   ; meta
   (key
     [:super :shift]
     "/"
     #((. (require "awful.hotkeys_popup") :show_help) nil (awful.screen.focused))
     {:description "show keybinds" :group "awesome"})
   (key
     [:super :shift]
     "r"
     awesome.restart
     {:description "reload awesome" :group "awesome"})
   (key
     [:super :shift]
     "e"
     #(awful.spawn "power-menu")
     {:description "open power menu" :group "awesome"})

   ; general
   (key
     [:super]
     "m"
     #(awful.spawn "wpctl set-mute @DEFAULT_SINK@ toggle")
     {:description "toggle mute" :group "awesome"})
   (key
     [:super :alt]
     "m"
     #(each [_ c (ipairs (client.get))]
        (when (= c.class "mpv")
          ; xdotool doesn't work here if the mpv window is focused
          (if (= c client.focus)
              (do
                (root.fake_input "key_release" "Super_L")
                (root.fake_input "key_release" "Alt_L")
                (root.fake_input "key_release" "m")
                (root.fake_input "key_press" "m")
                (root.fake_input "key_release" "m")
                (root.fake_input "key_press" "Super_L")
                (root.fake_input "key_press" "Alt_L"))
              (awful.spawn ["xdotool" "key" "--window" (tostring c.window) "m"]))))
     {:description "toggle mute on all mpv windows" :group "awesome"})
   (key
     [:super :ctrl]
     "m"
     #(each [_ c (ipairs (labels.clients-with-all-labels ["gaming"]))]
        (naughty.notify {:title "TEST"}))
     {:description "label buh" :group "awesome"})

   ; window navigation
   (key
     [:super]
     "j"
     #(awful.client.focus.byidx 1)
     {:description "previous window" :group "awesome"})
   (key
     [:super]
     "k"
     #(awful.client.focus.byidx -1)
     {:description "next window" :group "awesome"})
   (key
     [:super]
     "u"
     #(awful.client.urgent.jumpto)
     {:description "focus urgent window" :group "awesome"})
   (key
     [:super :alt]
     "r"
     #(awful.tag.setmwfact 0.50)
     {:description "reset master ratio" :group "awesome"})
   (key
     [:super]
     "h"
     #(awful.tag.incmwfact -0.02)
     {:description "decrease master ratio" :group "awesome"})
   (key
     [:super]
     "l"
     #(awful.tag.incmwfact 0.02)
     {:description "increase master ratio" :group "awesome"})
   (key
     [:super :alt]
     "h"
     #(awful.client.incwfact -0.02)
     {:description "decrease master ratio" :group "awesome"})
   (key
     [:super :alt]
     "l"
     #(awful.client.incwfact 0.02)
     {:description "increase master ratio" :group "awesome"})
   (key
     [:super :shift]
     "h"
     #(awful.tag.incnmaster 1)
     {:description "increase number of master clients" :group "awesome"})
   (key
     [:super :shift]
     "l"
     #(awful.tag.incnmaster -1)
     {:description "decrease number of master clients" :group "awesome"})
   (key
     [:super :Control]
     "h"
     #(awful.tag.incncol 1)
     {:description "increase number of columns" :group "awesome"})
   (key
     [:super :Control]
     "l"
     #(awful.tag.incncol -1)
     {:description "decrease number of columns" :group "awesome"})

   ; applications
   (key
     [:super]
     "semicolon"
     ;#(awful.spawn "rofi -sort fzf -show combi -modes combi -combi-modes drun,run")
     #(awful.spawn "vicinae toggle -q ''")
     {:description "run command launcher" :group "awesome"})
   (key
     [:super]
     "Return"
     #(awful.spawn terminal)
     {:description "run terminal" :group "awesome"})
   (key
     [:super]
     "b"
     #(awful.spawn web-browser)
     {:description "run web browser" :group "awesome"})
   (key
     [:super :shift]
     "f"
     #(awful.spawn [terminal "-e" "ranger"])
     {:description "run ranger" :group "awesome"})
   (key
     [:super]
     "c"
     #(awful.spawn [terminal "--confirm-close-surface=false" "-e" "qalc"]
                         {:floating true
                          :ontop true
                          :height 1
                          :placement (+ awful.placement.top
                                        awful.placement.center_horizontal
                                        awful.placement.stretch_left
                                        awful.placement.stretch_right)})
     {:description "run calculator (qalc)" :group "awesome"})
   (key
     [:super]
     "Print"
     #(awful.spawn "flameshot gui")
     {:description "take screenshot" :group "awesome"})
   (key
     [:ctrl]
     "Print"
     #(awful.spawn "record")
     {:description "record screen" :group "awesome"})
   (key
     [:super :alt]
     "p"
     #(awful.spawn.with_shell "pkill picom || picom&disown")
     {:description "open clipboard in mpv" :group "awesome"})
   (key
     [:super :shift]
     "p"
     #(awful.spawn.with_shell "mpv --force-window=immediate \"$(xclip -selection clipboard -out)\"")
     {:description "open clipboard in mpv" :group "awesome"})

   ; tags
   (unpack (let [collection []]
             (for [i 1 9]
               (table.insert
                 collection
                 (key
                   [:super]
                   (tostring i)
                   (fn [index]
                     (local screen (awful.screen.focused))
                     (local tag (. screen.tags i))
                     (when tag (tag:view_only)))
                   {:description (.. "view tag " i) :group "tag"}))
               (table.insert
                 collection
                 (key
                   [:super :shift]
                   (tostring i)
                   (fn [index]
                     (when client.focus
                       (local tag (. client.focus.screen.tags i))
                       (when tag (client.focus:move_to_tag tag))))
                   {:description (.. "move window to tag " i) :group "tag"})))
             collection))
  ])

(client.connect_signal
  "request::default_mousebindings"
  #(awful.mouse.append_client_mousebindings
     [(button
        []
        1
        (fn [client]
          (client:activate {:context :mouse_click})))
      (button
        [:super]
        1
        (fn [client]
          (client:activate {:context "mouse_click" :action "mouse_move"})))
      (button
        [:super]
        2
        (fn [client]
          (set client.floating (not client.floating))
          (client:raise)))
      (button
        [:super]
        3
        (fn [client]
          (client:activate {:context "mouse_click" :action "mouse_resize"})))
     ]))

(client.connect_signal
  "request::default_keybindings"
  #(awful.keyboard.append_client_keybindings
    [
     (key
       [:super]
       "g"
       (fn [client]
         (if (= client (awful.client.getmaster))
           (do (awful.client.focus.byidx 1 client)
               (awful.client.swap.byidx 1 client))
           (awful.client.setmaster client)))
       {:description "change master window" :group "client"})

     (key
       [:super :alt]
       "f"
       (fn [client]
         (set client.maximized (not client.maximized))
         (client:raise))
       {:description "toggle maximized" :group "client"})

     (key
       [:super]
       "f"
       (fn [client]
         (set client.fullscreen (not client.fullscreen))
         (client:raise))
       {:description "toggle fullscreen" :group "client"})

     (key
       [:super]
       "t"
       (fn [client]
         (set client.ontop (not client.ontop)))
       {:description "toggle floating" :group "client"})

     (key
       [:super]
       "s"
       (fn [client]
         (set client.floating (not client.floating))
         (client:raise))
       {:description "toggle floating" :group "client"})

     (key
       [:super :shift]
       "q"
       (fn [client] (client:kill))
       {:description "close window" :group "client"})
    ]))
