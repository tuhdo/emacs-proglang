(use-package helm
  :init
  (defun helm-hide-minibuffer-maybe ()
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
        (overlay-put ov 'window (selected-window))
        (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
                                `(:background ,bg-color :foreground ,bg-color)))
        (setq-local cursor-type nil))))

  (defun set-helm-dotted-directory ()
    "Set the face of diretories for `.' and `..'"
    (set-face-attribute 'helm-ff-dotted-directory
                        nil
                        :foreground nil
                        :background nil
                        :inherit 'helm-ff-directory))

  (helm-mode 1)
  :config
  (progn
    (require 'helm-config)
    (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

    ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
    ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
    ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
    (global-set-key (kbd "C-c h") 'helm-command-prefix)
    (global-unset-key (kbd "C-x c"))

    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
    (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

    (when (executable-find "curl")
      (setq helm-google-suggest-use-curl-p t))

    (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
          helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
          helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
          helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
          helm-ff-file-name-history-use-recentf t
          helm-move-to-line-cycle-in-source     t
          helm-prevent-escaping-from-minibuffer t
          helm-bookmark-show-location           t
          helm-display-header-line              nil)

    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
    (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

    (global-set-key (kbd "M-x") 'helm-M-x)
    (setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x

    (global-set-key (kbd "M-.") 'helm-etags-select)
    (global-set-key (kbd "M-y") 'helm-show-kill-ring)
    (global-set-key (kbd "C-x b") 'helm-mini)
    (global-set-key (kbd "C-x C-f") 'helm-find-files)
    (global-set-key (kbd "<f1>") 'helm-resume)
    (global-set-key (kbd "C-h i") 'helm-info-at-point)
    (global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)
    (define-key emacs-lisp-mode-map (kbd "C-M-i") 'helm-lisp-completion-at-point)
    (define-key lisp-interaction-mode-map (kbd "C-M-i") 'helm-lisp-completion-at-point)
    (define-key read-expression-map (kbd "C-M-i") 'helm-lisp-completion-at-point)
    (define-key read-expression-map (kbd "<tab>") 'helm-lisp-completion-at-point)

    (with-eval-after-load 'ielm
      (define-key ielm-map (kbd "C-M-i") 'helm-lisp-completion-at-point))

    (setq helm-org-headings-fontify t)
    (global-set-key (kbd "C-c h o") 'helm-org-agenda-files-headings)

    (setq helm-semantic-fuzzy-match t
          helm-imenu-fuzzy-match    t
          helm-buffers-fuzzy-matching t
          helm-completion-in-region-fuzzy-match t)

    (helm-autoresize-mode)
    (setq helm-echo-input-in-header-line t)
    (setq helm-autoresize-max-height 20)
    (setq helm-autoresize-min-height 20)

    (add-hook 'helm-find-files-before-init-hook 'set-helm-dotted-directory)

    (use-package helm-ag
      :defer t)

    (use-package helm-swoop
      :bind (("C-c s" . helm-swoop)))

    (use-package helm-descbinds
      :init
      (helm-descbinds-mode 1)
      :bind
      (("C-c h h" . helm-descbinds))
      :config
      (setq helm-descbinds-window-style 'split-window))

    (use-package helm-gtags
      :commands (dired-mode c-mode c++-mode)
      :init
      (add-hook 'dired-mode-hook 'helm-gtags-mode)
      (add-hook 'c-mode-hook 'helm-gtags-mode)
      (add-hook 'c++-mode-hook 'helm-gtags-mode)
      (add-hook 'asm-mode-hook 'helm-gtags-mode)
      :config
      (setq helm-gtags-auto-update t)
      (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
      (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
      (define-key helm-gtags-mode-map (kbd "C-c t") 'helm-gtags-select))

    (use-package helm-dash
      :init
      (global-set-key (kbd "C-c d") 'helm-dash-at-point)
      (defun c-doc ()
        (setq helm-dash-docsets '("C")))
      (defun c++-doc ()
        (setq helm-dash-docsets '("C" "C++")))
      (add-hook 'c-mode-hook 'c-doc)
      (add-hook 'c++-mode-hook 'c++-doc))))

(provide 'setup-helm)
