(local beautiful (require :beautiful))
(local gears (require :gears))

(local theme-path (.. user-theme-dir "/basic"))
(local dpi beautiful.xresources.apply_dpi)

(local theme {
  :font "Fira Code Medium"

  :icon_font "Font Awesome 6 Free 9"

  :wallpaper (.. theme-path "/phos-face.png")

  :bg_normal "#101010"
  :bg_focus "#ff0000"
  :bg_urgent "#00ff00"

  :fg_normal "#cbf3f3"
  :fg_focus "#cbf3f3"
  :fg_urgent "#0000ff"

  :useless_gap (dpi 5)
  :border_width (dpi 2)
  :border_color_normal "#101010"
  :border_color_active "#cbf3f3"
  :border_color_marked "#0ff000"
  :tooltip_opacity 0

  :taglist_bg_focus "#41a387"
  :taglist_fg_focus "#101010"
  :taglist_bg_urgent "#cbf3f3"
  :taglist_fg_urgent "#101010"
  :taglist_fg_empty "#cbf3f370"
  :taglist_fg_occupied "#cbf3f3"

  :calendar_weekday_fg_color "#41a387"
  :calendar_normal_fg_color "#cbf3f370"
  :calendar_focus_bg_color "#101010"
})

(gears.wallpaper.maximized theme.wallpaper)

(beautiful.init theme)

(require "themes.basic.bar")
