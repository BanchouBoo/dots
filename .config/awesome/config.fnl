(local awful (require :awful))
(require :awful.autofocus)
(local naughty (require :naughty))
(local beautiful (require :beautiful))
(local gears (require :gears))

(fn is-restart []
    (awesome.register_xproperty "is_restart" "boolean")
    (local restart-detected (not= (awesome.get_xproperty "is_restart") nil))
    (awesome.set_xproperty "is_restart"  true)
    restart-detected)

(naughty.connect_signal
  "request::display_error"
  (fn [message startup]
    (naughty.notification {:urgency "critical"
                           :title (.. "An error occurred" (or (and startup " during startup") "."))
                           :message message})))

(global user-theme-dir (.. (gears.filesystem.get_configuration_dir) "/themes"))

(global terminal "ghostty")
(global web-browser "zen-bin")
(global mod "Mod4")

(require :bind)
(require :rule)
(require :themes.basic)

; define layouts
(let [l awful.layout.suit]
  (tag.connect_signal
    "request::default_layouts"
    #(awful.layout.append_default_layouts 
             [l.tile l.tile.left l.tile.bottom l.tile.top l.fair
              l.fair.horizontal l.spiral l.spiral.dwindle
              l.magnifier l.corner.nw l.floating l.max])))

; define tags
(screen.connect_signal
  "request::desktop_decoration"
  (fn [screen]
    (awful.tag
      [:1 :2 :3 :4 :5 :6 :7 :8 :9]
      screen
      (. awful.layout.layouts 1))))

(fn focus-hover []
  (let [client mouse.current_client]
    (when client
      (client:activate {:context "mouse_enter" :raise false}))))

(local focus-timer
  (gears.timer {:timeout (/ 1 60)
                :autostart false
                :callback focus-hover
                :single_shot true}))

; focus window when mouse enters it
(client.connect_signal
  "mouse::enter"
  (fn [client]
    (client:activate {:context "mouse_enter" :raise false})))

; focus window under cursor when changing tags
(tag.connect_signal
  "property::selected"
  #(focus-timer:start))

; focus window under cursor when closing a window
(client.connect_signal
  "request::unmanage"
  #(focus-timer:start))

; focus window under cursor when window changes tags
; unused for now since it also fires the signal when a new window is created
;(client.connect_signal
;  "tagged"
;  #(focus-timer:start))

; autostart programs
(when (not (is-restart))
  (awful.spawn.once "gentoo-pipewire-launcher")
  (awful.spawn.once "picom")
  (awful.spawn.once "touchegg")
  (awful.spawn.once "syncthing")
  (awful.spawn.once "lutris")
  (awful.spawn.once "steam")
  (awful.spawn.once "anki")
  (awful.spawn.once "discord")
  (awful.spawn.once "qbittorrent")
  (awful.spawn.once "unclutter --timeout 1"))
