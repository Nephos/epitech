(setq user-full-name "paul jarysta")
(setq user-mail-address "jaryst_p@epitech.eu")
(load-file "~/.emacs.d/std_comment.el")
(global-set-key [f11] 'std-file-header)

; Affiche le nombre de colonne et de ligne
(column-number-mode 1)
(line-number-mode 1)

; Supprime automatiquement les espaces en fin de ligne
(autoload 'nuke-trailing-whitespace "whitespace" nil t)

; Recherche automatique des fermetures et ouvertures des parenthèses
(load-library "paren")
(show-paren-mode 1)

; Affiche le numero de chaque ligne
(global-linum-mode 1)
(setq linum-format "%3d \u2502 ")

; Go to line 
(global-set-key (kbd "C-c g") 'goto-line)

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

