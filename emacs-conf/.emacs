(setq user-full-name "etienne bondot")
(setq user-mail-address "bondot_e@epitech.eu")
(load-file "~/.emacs.d/std_comment.el")
(global-set-key [f11] 'std-file-header)

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

