(local beautiful (require :beautiful))
(local gears (require :gears))
(local ruled-notification (require :ruled.notification))

(local theme-path (.. user-theme-dir "/basic"))
(local dpi beautiful.xresources.apply_dpi)

(local theme {
  :font "Fira Code Medium"

  :icon_font "Font Awesome 6 Free 9"

  ;:wallpaper (.. theme-path "/phos-face.png")
  :wallpaper (.. theme-path "/starry-sky.png")

  :bg_normal "#132530"
  :bg_focus "#ff0000"
  :bg_urgent "#a33c3d"

  :fg_normal "#edc0d7"
  :fg_focus "#edc0d7"
  :fg_urgent "#101010"

  :useless_gap (dpi 5)
  :border_width (dpi 2)
  :border_color_normal "#132530"
  :border_color_active "#edc0d7"
  :border_color_marked "#0ff000"
  :tooltip_opacity 0

  :taglist_bg_focus "#edc0d7"
  :taglist_fg_focus "#132530"
  :taglist_bg_urgent "#db7272"
  :taglist_fg_urgent "#132530"
  :taglist_fg_empty "#edc0d770"
  :taglist_fg_occupied "#edc0d7"

  :calendar_weekday_fg_color "#edc0d7"
  :calendar_normal_fg_color "#edc0d770"
  :calendar_focus_bg_color "#132530"
})

(ruled-notification.connect_signal
  "request::rules"
  #(ruled-notification.append_rule
     {:rule {:urgency "critical"}
      :properties {:bg theme.bg_urgent :fg theme.fg_urgent}}))

(gears.wallpaper.maximized theme.wallpaper)

(beautiful.init theme)

(require "themes.basic.bar")
