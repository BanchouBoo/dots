;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; greatly increases startup time of terminal emacs, may have unknown side effects
;; the function is for terminal-specific initialization
;; (unless (display-graphic-p)
;;   (advice-add #'tty-run-terminal-initialization :override #'ignore)
;;   (add-transient-hook! 'pre-command-hook
;;     (advice-remove #'tty-run-terminal-initialization #'ignore)
;;     (dolist (frame (frame-list))
;;       (tty-run-terminal-initialization frame nil t))))
;; (advice-add #'tty-run-terminal-initialization :override #'ignore)

;; set theme
(setq doom-theme 'xresources)

;; SIGUSR1 to reload theme
(defun sigusr1-handler ()
  (interactive)
  (doom/reload-theme))
(define-key special-event-map [sigusr1] 'sigusr1-handler)

;; font stuff
(setq doom-font (font-spec :family "Fira Code Medium" :size 18))

;; allow moving cursor one character beyond the end of line
(setq evil-move-beyond-eol t)

;; relative line numbers
(setq display-line-numbers-type 'visual)

;; set org directory
(setq org-directory "~/org/agenda/")

;; org capture templates
(after! org
  (setq org-capture-templates
        '(("f" "Food Log" entry
           (file+olp+datetree "~/org/food.org")
           "* %? @ %<%I:%M%p>\n%T\n%^{Type}p" :time-prompt t))
        )
)

;; word wrap in org mode
(add-hook! org-mode visual-line-mode)

;; tab width
(setq-default tab-width 4)

;; force tabs in csharp-mode
(add-hook! csharp-mode (setq-local indent-tabs-mode t))

;; increase snipe scope
(setq evil-snipe-scope 'buffer)

;; use avy in all windows
(setq avy-all-windows t)

;; keybinds for leader
(map! :leader
      ;; jumps
      (:prefix ("j" . "jump")
        "l" #'avy-goto-line
        "j" #'avy-goto-char-timer
        "w" #'ace-window
      )

      ;; opens
      (:prefix "o"
        "l" #'ace-link
      )
)

;; keybinds for normal mode
(map! :n "gl" #'evil-end-of-line
      :n "gh" #'evil-beginning-of-line
)

;; Disable mouse
(defun silence ()
  (interactive))
(dolist (mouse '(
                 "<down-mouse-1>" "<drag-mouse-1>" "<mouse-1>" ;; left click
                 "<mouse-2>" ;; middle click
                 "<down-mouse-3>" "<mouse-3>" ;; right click
                 "<mouse-4>" ;; scroll up
                 "<mouse-5>" ;; scroll down
                 ))
  (global-set-key (kbd mouse) 'silence)
  (define-key evil-normal-state-map (kbd mouse) 'silence)) ;; ...in GUI
(xterm-mouse-mode -1) ;; ...in terminal

;; Speed up leader key
(setq which-key-idle-delay 0.01)
