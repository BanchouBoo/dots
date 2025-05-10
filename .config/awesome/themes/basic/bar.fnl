(local awful (require :awful))
(local wibox (require :wibox))
(local beautiful (require :beautiful))
(local dpi beautiful.xresources.apply_dpi)

(local clock (wibox.widget.textclock "%a %B %e %I:%M "))
(local calendar (awful.widget.calendar_popup.month))
(calendar:attach clock "tr" {:on_hover false})

(local mute_indicator
  (awful.widget.watch
    "wpctl get-volume @DEFAULT_AUDIO_SINK@"
    (/ 1 60)
    #(set $1.opacity
       (if ($2:find "[MUTED]")
           "1.0"
           "0.0"))))
(mute_indicator:set_text "\u{f6a9}")
(set mute_indicator.font beautiful.icon_font)

; TODO: not working
(local wifi_indicator
  (awful.widget.watch
    "nmcli general | awk 'FNR==2 {print $2}'"
    (/ 1 60)
    #($1:set_text
       (case $2
         "full" "\u{f1eb}"))))

(screen.connect_signal
  "request::desktop_decoration"
  (fn [screen]
    (set screen.taglist (awful.widget.taglist
                          {:screen screen
                           :filter awful.widget.taglist.filter.all
                           :buttons [(awful.button {} 1 (fn [tag] (tag:view_only)))]}))
    (set screen.layouts (awful.widget.layoutbox
                          {:screen screen
                           :buttons [(awful.button {} 1 (fn [] (awful.layout.inc 1)))
                                    (awful.button {} 3 (fn [] (awful.layout.inc -1)))]}))
    (set screen.wibar (awful.wibar
                        {:screen screen
                         :position "top"
                         :height (dpi 25)
                         :bg beautiful.bg_normal
                         :fg beautiful.fg_normal
                         :widget {1 {1 {1 screen.taglist
                                        2 screen.layouts
                                        :spacing (dpi 10)
                                        :layout wibox.layout.fixed.horizontal}
                                     3 {1 mute_indicator
                                        2 clock
                                        :spacing (dpi 10)
                                        :layout wibox.layout.fixed.horizontal}
                                     :layout wibox.layout.align.horizontal}
                                  :widget wibox.container.margin}}))))
