(local awful (require :awful))

(awful.keyboard.append_global_keybindings
  [
   ; meta
   (awful.key
     [mod :Shift]
     "/"
     #((. (require "awful.hotkeys_popup") :show_help) nil (awful.screen.focused))
     {:description "show keybinds" :group "awesome"})
   (awful.key
     [mod :Shift]
     "r"
     awesome.restart
     {:description "reload awesome" :group "awesome"})
   (awful.key
     [mod :Shift]
     "e"
     #(awful.spawn "power-menu")
     {:description "open power menu" :group "awesome"})

   ; general
   (awful.key
     [mod]
     "m"
     #(awful.spawn "wpctl set-mute @DEFAULT_SINK@ toggle")
     {:description "previous window" :group "awesome"})

   ; window navigation
   (awful.key
     [mod]
     "j"
     #(awful.client.focus.byidx 1)
     {:description "previous window" :group "awesome"})
   (awful.key
     [mod]
     "k"
     #(awful.client.focus.byidx -1)
     {:description "next window" :group "awesome"})
   (awful.key
     [mod :Mod1]
     "r"
     #(awful.tag.setmwfact 0.50)
     {:description "reset master ratio" :group "awesome"})
   (awful.key
     [mod]
     "h"
     #(awful.tag.incmwfact -0.02)
     {:description "decrease master ratio" :group "awesome"})
   (awful.key
     [mod]
     "l"
     #(awful.tag.incmwfact 0.02)
     {:description "increase master ratio" :group "awesome"})
   (awful.key
     [mod :Mod1]
     "h"
     #(awful.client.incwfact -0.02)
     {:description "decrease master ratio" :group "awesome"})
   (awful.key
     [mod :Mod1]
     "l"
     #(awful.client.incwfact 0.02)
     {:description "increase master ratio" :group "awesome"})
   (awful.key
     [mod :Shift]
     "h"
     #(awful.tag.incnmaster 1)
     {:description "increase number of master clients" :group "awesome"})
   (awful.key
     [mod :Shift]
     "l"
     #(awful.tag.incnmaster -1)
     {:description "decrease number of master clients" :group "awesome"})
   (awful.key
     [mod :Control]
     "h"
     #(awful.tag.incncol 1)
     {:description "increase number of columns" :group "awesome"})
   (awful.key
     [mod :Control]
     "l"
     #(awful.tag.incncol -1)
     {:description "decrease number of columns" :group "awesome"})

   ; applications
   (awful.key
     [mod]
     "semicolon"
     #(awful.spawn "rofi -sort fzf -show combi -modes combi -combi-modes drun,run")
     {:description "run command launcher" :group "awesome"})
   (awful.key
     [mod]
     "Return"
     #(awful.spawn terminal)
     {:description "run terminal" :group "awesome"})
   (awful.key
     [mod]
     "b"
     #(awful.spawn web-browser)
     {:description "run web browser" :group "awesome"})
   (awful.key
     [mod :Shift]
     "f"
     #(awful.spawn [terminal "-e" "ranger"])
     {:description "run ranger" :group "awesome"})
   (awful.key
     [mod]
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
   (awful.key
     [mod]
     "Print"
     #(awful.spawn "flameshot gui")
     {:description "take screenshot" :group "awesome"})
   (awful.key
     [mod :Shift]
     "p"
     #(awful.spawn.with_shell "mpv --force-window=immediate \"$(xclip -out)\"")
     {:description "open clipboard in mpv" :group "awesome"})

   ; tags
   (awful.key
     {:modifiers [mod]
      :keygroup "numrow"
      :description "view tag"
      :group "tag"
      :on_press (fn [index]
                  (local screen (awful.screen.focused))
                  (local tag (. screen.tags index))
                  (when tag (tag:view_only)))})

   (awful.key
     {:modifiers [mod :Shift]
      :keygroup "numrow"
      :description "move window to tag"
      :group "tag"
      :on_press (fn [index]
                  (when client.focus
                    (local tag (. client.focus.screen.tags index))
                    (when tag (client.focus:move_to_tag tag))))})
  ])

(client.connect_signal
  "request::default_mousebindings"
  #(awful.mouse.append_client_mousebindings
     [(awful.button
        []
        1
        (fn [client]
          (client:activate {:context :mouse_click})))
      (awful.button
        [mod]
        1
        (fn [client]
          (client:activate {:context "mouse_click" :action "mouse_move"})))
      (awful.button
        [mod]
        2
        (fn [client]
          (set client.floating (not client.floating))
          (client:raise)))
      (awful.button
        [mod]
        3
        (fn [client]
          (client:activate {:context "mouse_click" :action "mouse_resize"})))]))

(client.connect_signal
  "request::default_keybindings"
  #(awful.keyboard.append_client_keybindings
    [
     (awful.key
       [mod]
       "g"
       (fn [client]
         (if (= client (awful.client.getmaster))
           (do (awful.client.focus.byidx 1 client)
               (awful.client.swap.byidx 1 client))
           (awful.client.setmaster client)))
       {:description "change master window" :group "client"})

     (awful.key
       [mod]
       "f"
       (fn [client]
         (set client.fullscreen (not client.fullscreen))
         (client:raise))
       {:description "toggle fullscreen" :group "client"})

     (awful.key
       [mod]
       "s"
       (fn [client]
         (set client.floating (not client.floating))
         (client:raise))
       {:description "toggle floating" :group "client"})

     (awful.key
       [mod :Shift]
       "q"
       (fn [client] (client:kill))
       {:description "close window" :group "client"})
    ]))
