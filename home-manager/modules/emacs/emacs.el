;; Basic Settings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(setq user-emacs-directory "~/.emacs.d.agda/")

; (setq lsp-use-plists t)

;; transparent background in terminal
;;(set-face-attribute 'default nil :background nil)

(setq vc-follow-symlinks t)

;; Again the emacs default is too low 4k considering that the some of the
;; language server responses are in 800k - 3M range.
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; The default setting is too low for lsp-mode's needs due to the fact that
;; client/server communication generates a lot of memory/garbage. You have two
;; options:
(setq gc-cons-threshold 100000000)

;; HACK: Disable warning with "package cl is deprecated".
(setq byte-compile-warnings '(cl-functions))

;; Disable annoying hsplit with emacs help on every program launch.
(setq inhibit-startup-screen t)

;; No fucking tabs, ever.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default evil-shift-width 4)

(menu-bar-mode -1)
(scroll-bar-mode 0)
(tool-bar-mode -1)

;; esc always quits
(define-key minibuffer-local-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-ns-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-completion-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-must-match-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-isearch-map [escape] 'keyboard-escape-quit)
(global-set-key [escape] 'keyboard-escape-quit)

;; Put annoying autosave and backup files in fixed dir.
(setq auto-save-file-name-transforms
  `((".*" ,(concat user-emacs-directory "auto-save/") t))) 
(setq backup-directory-alist
  `(("." . ,(expand-file-name
              (concat user-emacs-directory "backups/")))))

;; Disable horrible error bell
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; Package Repositories ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;;(package-refresh-contents)

;; Vim Keybindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq evil-shift-width 2)

(unless (package-installed-p 'evil)
  (package-install 'evil))
(require 'evil)
(evil-mode 1)
(evil-set-leader 'normal (kbd ","))
(evil-set-leader 'visual (kbd ","))

;; Back-to-Normal-Mode with "jk"
(unless (package-installed-p 'evil-escape)
  (package-install 'evil-escape))
(evil-escape-mode 1)
(setq-default evil-escape-key-sequence "jk")
(setq-default evil-escape-delay 1.0)

;; Disable the escape sequence in all modes, which are not insert or visual mode.
(setq evil-escape-inhibit-functions '((lambda () (not (or (evil-insert-state-p) (evil-visual-state-p) (evil-replace-state-p))))))

;; In visual mode use 'fd' instead of 'jk' to goto normal mode,
;; because otherwise I accidentally go back while selecting lines.
;; (push 'visual evil-escape-excluded-states)

(add-hook 'evil-visual-state-entry-hook (lambda ()
 (setq-default evil-escape-key-sequence "fd")
))
(add-hook 'evil-visual-state-exit-hook (lambda ()
 (setq-default evil-escape-key-sequence "jk")
))

;; Half-page scrolling with C-d and C-u.
(defun window-half-height ()
 (max 1 (/ (1- (window-height (selected-window))) 2)))
(defun scroll-half-page-down ()
 (interactive)
 (scroll-up (window-half-height)))
(defun scroll-half-page-up ()         
 (interactive)                    
 (scroll-down (window-half-height)))
(evil-define-key 'normal  'global (kbd "C-d") 'scroll-half-page-down)
(evil-define-key 'insert  'global (kbd "C-d") 'scroll-half-page-down)
(evil-define-key 'replace 'global (kbd "C-d") 'scroll-half-page-down)
(evil-define-key 'visual  'global (kbd "C-d") 'scroll-half-page-down)
;; (evil-define-key 'normal  'global (kbd "C-u") 'scroll-half-page-up)
;; (evil-define-key 'insert  'global (kbd "C-u") 'scroll-half-page-up)
;; (evil-define-key 'replace 'global (kbd "C-u") 'scroll-half-page-up)
;; (evil-define-key 'visual  'global (kbd "C-u") 'scroll-half-page-up)

;; doesn't work for some reason.
; (setq evil-want-C-u-scroll t)
; (setq evil-want-C-d-scroll t)

;; Scaling font size. We use this package, because the builtin scaling
;; functions only change the size for the current buffer.
(unless (package-installed-p 'default-text-scale)
  (package-install 'default-text-scale))
(require 'default-text-scale)
(global-set-key (kbd "C-+") 'default-text-scale-increase)
(global-set-key (kbd "C--") 'default-text-scale-decrease)

;; Buffer navigation
(global-set-key (kbd "M-h") 'previous-buffer)
(global-set-key (kbd "M-l") 'next-buffer)
(evil-define-key 'normal  'global (kbd "SPC TAB") 'previous-buffer)
(evil-define-key 'normal  'global (kbd "-") 'comment-line)
(evil-define-key 'visual  'global (kbd "-") 'comment-or-uncomment-region)

(evil-define-key 'normal  'global (kbd "SPC u") 'universal-argument)
(evil-define-key 'visual  'global (kbd "SPC u") 'universal-argument)

;; Centered Cursor ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Navigating up or down with j and k keeps the cursor in the middle, and
;; instead moves the text up or down.

;; Variant 1: Builtin Settings
;; Most performant, but going upwards sometimes alternates the middle line with
;; the line one above...
(setq scroll-preserve-screen-position t
      scroll-conservatively 0
      maximum-scroll-margin 0.5
      scroll-margin 99999)

;; Variant 2: centered-cursor-mode (slow)
;; (unless (package-installed-p 'centered-cursor-mode)
;;   (package-install 'centered-cursor-mode))
;; (centered-cursor-mode 1)

;; Variant 3: own alternative (slow)
;; (add-hook 'post-command-hook (lambda () (evil-scroll-line-to-center nil)))

;; Snippets ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'yasnippet)
  (package-install 'yasnippet))
(require 'yasnippet)

;; Globally enable it
(yas-global-mode 1)

;; Just load it, to then enable it on a per-buffer basis, by calling `yas-minor-mode`.
;; (yas-reload-all)


;; Align ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; Note: To align string between " " use "\( +\)"
(defun align-regexp-repeat (start end regexp)
  "Repeat alignment with respect to
   the given regular expression."
  (interactive "r\nsAlign regexp repeatedly: ")
  (align-regexp start end
                regexp 1 1 t))

(defun align-regexp-between (start end regexpBefore regexpAfter)
  "Repeat alignment with respect to the given regular expression."
  (interactive "r\nsAlign regexp before: \nsAlign regexp after: ")
  (align-regexp start end
                (concat regexpBefore "\\(\\s-*\\)" regexpAfter) 1 1 t))

;; (define-key evil-visual-state-map (kbd "a") 'align-regexp-repeat)
;; (define-key evil-visual-state-map (kbd "a") 'align-regexp)
(define-key evil-visual-state-map (kbd "a") 'align-regexp-between)

;; Helm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'helm)
  (package-install 'helm))
(require 'helm)
(global-set-key (kbd "C-c h") 'helm-command-prefix)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

; (setq helm-autoresize-max-height 0)
; (setq helm-autoresize-min-height 20)
; (helm-autoresize-mode 1)

;; Override default emacs functions with the corrsponding helm-enhanced
;; functions. (Not that I ever use those non-vim keybindings...)
;;(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

(setq helm-grep-ag-command (concat "rg"
                                   " --color=never"
                                   " --smart-case"
                                   " --no-heading"
                                   " --line-number %s %s %s")
      helm-grep-file-path-style 'relative)

(unless (package-installed-p 'helm-ls-git)
  (package-install 'helm-ls-git))
(require 'helm-ls-git)

;; From https://www.manueluberti.eu/emacs/2020/02/22/ripgrepping-with-helm/
(defun mu-helm-rg (directory &optional with-types)
  "Search in DIRECTORY with RG.
With WITH-TYPES, ask for file types to search in."
  (interactive "P")
  (require 'helm-adaptive)
  (helm-grep-ag-1 (expand-file-name directory)
                  (helm-aif (and with-types
                                 (helm-grep-ag-get-types))
                      (helm-comp-read
                       "RG type: " it
                       :must-match t
                       :marked-candidates t
                       :fc-transformer 'helm-adaptive-sort
                       :buffer "*helm rg types*"))))
(defun mu-helm-project-search (&optional with-types)
  "Search in current project with RG.
With WITH-TYPES, ask for file types to search in."
  (interactive "P")
  (mu-helm-rg (mu--project-root) with-types))
(defun mu-helm-file-search (&optional with-types)
  "Search in `default-directory' with RG.
With WITH-TYPES, ask for file types to search in."
  (interactive "P")
  (mu-helm-rg default-directory with-types))
(defun mu--project-root ()
  "Return the project root directory or `helm-current-directory'."
  (require 'helm-ls-git)
  (if-let (dir (helm-ls-git-root-dir))
      dir
    (helm-current-directory)))

;; Provides a command to open a helm filterlist of all the currently active
;; keybindings.
;; (unless (package-installed-p 'helm-descbinds)
;;   (package-install 'helm-descbinds))
;; (require 'helm-descbinds)
;; (helm-descbinds-mode)

(evil-define-key 'normal 'global (kbd "SPC b") 'helm-buffers-list)
(evil-define-key 'normal 'global (kbd "SPC x") 'helm-M-x)
(evil-define-key 'normal 'global (kbd "SPC f") 'helm-find-files)
(evil-define-key 'normal 'global (kbd "SPC P") 'helm-browse-project)
(evil-define-key 'normal 'global (kbd "SPC p") 'projectile-find-file)
(evil-define-key 'normal 'global (kbd "SPC r") 'projectile-replace)
(evil-define-key 'normal 'global (kbd "SPC R") 'projectile-replace-regexp)
(evil-define-key 'normal 'global (kbd "SPC /") 'mu-helm-project-search)
(evil-define-key 'normal 'global (kbd "SPC SPC") 'helm-occur)
(evil-define-key 'normal 'global (kbd "SPC d") 'kill-this-buffer)
;; (evil-define-key 'normal 'global (kbd "SPC ?") 'helm-descbinds)
(evil-define-key 'normal 'global (kbd "SPC e e") 'flycheck-list-errors)
(evil-define-key 'normal 'global (kbd "SPC e n") 'flycheck-next-error)
(evil-define-key 'normal 'global (kbd "SPC e p") 'flycheck-previous-error)

(helm-mode 1)

;; Display Keybindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display keybindings on the bottom like in spacemacs.

(unless (package-installed-p 'which-key)
  (package-install 'which-key))
(require 'which-key)
(which-key-mode 1)

;; Set the time delay (in seconds) for the which-key popup to appear. A value of
;; zero might cause issues so a non-zero value is recommended.
(setq which-key-idle-delay 0.2) ; Default 1.0
(setq which-key-idle-secondary-delay 0.02) ; Default nil

;; Set the maximum length (in characters) for key descriptions (commands or
;; prefixes). Descriptions that are longer are truncated and have ".." added.
(setq which-key-max-description-length 40) ; Default 27

;; The maximum number of columns to display in the which-key buffer. nil means
;; don't impose a maximum.
(setq which-key-max-display-columns nil) ; Default nil

;; Projectile ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'rg)
  (package-install 'rg))
(require 'rg)

(unless (package-installed-p 'projectile)
  (package-install 'projectile))
(require 'projectile)

(setq-default projectile-project-search-path '("~/Development/projects/"))

(setq-default projectile-enable-caching nil)

(setq-default projectile-indexing-method 'alien)

; Ignored with indexing-method 'alien.
;; (setq projectile-globally-ignored-file-suffixes '(
;;   "o"
;;   "agdai"
;;   "aux" "bbl" "blg" "ptb"
;; ))

;; 
;; ;; Due to "alien" indexing method, globally ignore folders/files by
;; ;; re-defining "rg" args
;; (mapc (lambda (item)
;;         (add-to-list 'projectile-globally-ignored-directories item))
;;       '("Backup" "backup" "auto" "archived"))
;; ;; files to be ignored should be listed in "~/.emacs.d/rg_ignore"
;; 
;; ;; Use the faster searcher to handle project files: ripgrep "rg"
;; ; (when (and (not (executable-find "fd"))
;;            ; (executable-find "rg"))
;;   (setq projectile-generic-command
;;         (let ((rg-cmd ""))
;;           (dolist (dir projectile-globally-ignored-directories)
;;             (setq rg-cmd (format "%s --glob '!%s'" rg-cmd dir)))
;;           (setq rg-ignorefile
;;                 (concat "--ignore-file" " "
;;                         (expand-file-name "rg_ignore" user-emacs-directory)))
;;           (concat "rg -0 --files --color=never --hidden" rg-cmd " " rg-ignorefile)))
;; ; )

(projectile-mode +1)


;; ;;; Default rg arguments
;;   ;; https://github.com/BurntSushi/ripgrep
;;   (when (executable-find "rg")
;;     (progn
;;       (defconst modi/rg-arguments
;;         `("--line-number"                     ; line numbers
;;           "--smart-case"
;;           "--follow"                          ; follow symlinks
;;           "--mmap")                           ; apply memory map optimization when possible
;;         "Default rg arguments used in the functions in `projectile' package.")
;; 
;;       (defun modi/advice-projectile-use-rg ()
;;         "Always use `rg' for getting a list of all files in the project."
;;         (mapconcat 'identity
;;                    (append '("\\rg") ; used unaliased version of `rg': \rg
;;                            modi/rg-arguments
;;                            '("--null" ; output null separated results,
;;                              "--files")) ; get file names matching the regex '' (all files)
;;                    " "))
;; 
;;       (advice-add 'projectile-get-ext-command :override #'modi/advice-projectile-use-rg)))


;; File Tree ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'neotree)
  (package-install 'neotree))
(require 'neotree)

(evil-define-key 'normal 'global (kbd "SPC t") 'neotree)

;; Fix keybinding collisions with `evil-mode`.
(add-hook 'neotree-mode-hook (lambda ()
  (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
  (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
  (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
  ; (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
  (define-key evil-normal-state-local-map (kbd "RET") (lambda () (interactive) (neotree-enter) (neotree-hide)))
  (define-key evil-normal-state-local-map (kbd "i")   (lambda () (interactive) (neotree-enter) (neotree-hide)))
  (define-key evil-normal-state-local-map (kbd "l")   (lambda () (interactive) (neotree-enter) (neotree-hide)))
  (define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
  (define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
  (define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
  (define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
  (define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)
))

(setq neo-hidden-regexp-list '(
  ;; defaults
  "^\\." "\\.pyc$" "~$" "^#.*#$" "\\.elc$" "\\.o$"
  ;; python
  "__pycache__"
  ;; agda
  "\\.agdai$"
))

;; Every time when the neotree window is opened, let it find current file and jump to node.
(setq neo-smart-open t)

;; When running ‘projectile-switch-project’ (C-c p p), ‘neotree’ will change root automatically.
(setq projectile-switch-project-action 'neotree-projectile-action)

;; NeoTree can be opened (toggled) at projectile project root as follows:
;; (defun neotree-project-dir ()
;;   "Open NeoTree using the git root."
;;   (interactive)
;;   (let ((project-dir (projectile-project-root))
;;         (file-name (buffer-file-name)))
;;     (neotree-toggle)
;;     (if project-dir
;;         (if (neo-global--window-exists-p)
;;             (progn
;;               (neotree-dir project-dir)
;;               (neotree-find file-name)))
;;       (message "Could not find git project root."))))
;; (global-set-key [f8] 'neotree-project-dir)

;; Language: Python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'python-mode-hook (lambda ()
  (eglot-ensure)
  (company-mode)
  (evil-define-key 'normal 'local (kbd "<leader>r")   'eglot-rename)
  (evil-define-key 'visual 'local (kbd "<leader>f")   'eglot-format)
  (evil-define-key 'normal 'local (kbd "<leader>f")   'eglot-format-buffer)
  (evil-define-key 'normal 'local (kbd "<leader>a")   'eglot-code-actions)
  (evil-define-key 'normal 'local (kbd "<leader>i")   'eglot-inlay-hints-mode)
  (evil-define-key 'normal 'local (kbd "<leader>e")   'flymake-show-buffer-diagnostics)
  (evil-define-key 'normal 'local (kbd "<leader>E")   'flymake-show-project-diagnostics)
  (evil-define-key 'normal 'local (kbd "<leader>g")   'xref-find-definitions)
  (evil-define-key 'normal 'local (kbd "<leader>G")   'xref-go-back)
  (evil-define-key 'normal 'local (kbd "<leader>c")   'completion-at-point)

))

;; Language: Agda ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; snippet definitions, only KEY and TEMPLATE are actually mandatory.
;; (KEY TEMPLATE NAME CONDITION GROUP EXPAND-ENV LOAD-FILE KEYBINDING UUID SAVE-FILE) 
(yas-define-snippets 'agda2-mode '(
     ("inat" "open import Data.Nat using (ℕ; zero; suc)\n" "open import Data.Nat")
     ("ifin" "open import Data.Fin (Fin; zero; suc)\n" "open import Data.Fin")
     ("ibool" "open import Data.Bool renaming (Bool to 𝔹) using (true; false)\n" "open import Data.Bool")
     ("ilist" "open import Data.List using (List; []; _∷_)\n" "open import Data.List")
     ("iprod" "open import Data.Product using (_×_; _,_; proj₁; proj₂; Σ-syntax; ∃-syntax)\n" "open import Data.Product")
     ("isum" "open import Data.Sum using (_⊎_; inj₁; inj₂)\n" "open import Data.Sum")
     ("iunit" "open import Data.Unit using (⊤; tt)\n" "open import Data.Unit")
     ("iempty" "open import Data.Empty using (⊥; ⊥-elim)\n" "open import Data.Empty")
     ("iany" "open import Data.List.Relation.Unary.Any using (Any; here; there)\nopen import Data.List.Membership.Propositional using (_∈_)\n" "open import Data.Any")
     ("iall" "open import Data.List.Relation.Unary.All using (All; []; _∷_)\n" "open import Data.All")
     ("ivec" "open import Data.Vec using (Vec; []; _∷_)\n" "open import Data.Vec")
     ("ieq" "open import Relation.Binary.PropositionalEquality using (_≡_; refl; sym; trans; cong; subst; module ≡-Reasoning)\nopen ≡-Reasoning\n"
            "open import Relation.Binary.PropositionalEquality")
     ("iheq" "open import Relation.Binary.HeterogeneousEquality as H using (_≅_; refl; module ≅-Reasoning)" "open import Relation.Binary.HeterogeneousEquality")
     ("ilevel" "open import Level using (Level; _⊔_; 0ℓ) renaming (suc to lsuc)" "open import Level")
     ("def" "${1:f} : ${2:?}\n$1 = ${0:?}" "Definition")
     ("data" "data ${1:D} : ${2:Set} where\n  $0" "Data Declaration")
     ("rec" "record ${1:R} : ${2:Set} where\n  field\n    $0" "Record Declaration")
     ("mod" "module ${1:M} where\n  $0" "Module Declaration")
     ("erc" "begin\n  ?\n≡⟨ ? ⟩\n  ?\n∎" "Equational Reasoning")
     ("ero" "let open ≡-Reasoning in\nbegin\n  ?\n≡⟨ ? ⟩\n  ?\n∎" "Equational Reasoning with Import")
     ("eri" "begin ? ≡⟨ ? ⟩ ? ∎" "Equational Reasoning Inline")
)) 

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(add-to-list 'auto-mode-alist '("\\.lagda.md\\'" . agda2-mode))
(add-to-list 'auto-mode-alist '("\\.lagda.tex\\'" . agda2-mode))

(add-hook 'agda2-mode-hook (lambda ()
  (evil-define-key 'normal 'local (kbd "<leader>l")   'agda2-load)
  (evil-define-key 'normal 'local (kbd "<leader>l")   (lambda () (interactive)
                                                        (setq-default projectile-indexing-method 'native)
                                                        (agda2-load))) ;; Hack, see below.....
  (evil-define-key 'normal 'local (kbd "<leader>,")   'agda2-goal-and-context)
  (evil-define-key 'normal 'local (kbd "<leader>.")   'agda2-goal-and-context-and-inferred)
  (evil-define-key 'normal 'local (kbd "<leader>:")   'agda2-goal-and-context-and-checked)
  (evil-define-key 'normal 'local (kbd "<leader>f")   'agda2-next-goal)
  (evil-define-key 'normal 'local (kbd "<leader>b")   'agda2-previous-goal)
  (evil-define-key 'normal 'local (kbd "<leader>SPC") 'agda2-give)
  (evil-define-key 'normal 'local (kbd "<leader>=")   'agda2-show-constraints)
  (evil-define-key 'normal 'local (kbd "<leader>?")   'agda2-show-goals)
  (evil-define-key 'normal 'local (kbd "<leader>a")   'agda2-mimer-maybe-all)
  (evil-define-key 'normal 'local (kbd "<leader>c")   'agda2-make-case)
  (evil-define-key 'normal 'local (kbd "<leader>e")   'agda2-show-context)
  (evil-define-key 'normal 'local (kbd "<leader>h")   'agda2-helper-function-type)
  (evil-define-key 'normal 'local (kbd "<leader>i")   'agda2-infer-type-maybe-toplevel)
  (evil-define-key 'normal 'local (kbd "<leader>I")   'agda2-display-implicit-arguments)
  (evil-define-key 'normal 'local (kbd "<leader>m")   'agda2-module-contents-maybe-toplevel)
  (evil-define-key 'normal 'local (kbd "<leader>n")   'agda2-compute-normalised-maybe-toplevel)
  (evil-define-key 'normal 'local (kbd "<leader>r")   'agda2-refine)
  (evil-define-key 'normal 'local (kbd "<leader>R")   'agda2-restart)
  (evil-define-key 'normal 'local (kbd "<leader>s")   'agda2-solveAll)
  (evil-define-key 'normal 'local (kbd "<leader>t")   'agda2-goal-type)
  (evil-define-key 'normal 'local (kbd "<leader>w")   'agda2-why-in-scope-maybe-toplevel)
  (evil-define-key 'normal 'local (kbd "<leader>G")   'agda2-go-back)
  (evil-define-key 'normal 'local (kbd "<leader>g")   'agda2-goto-definition-keyboard) 
  (evil-define-key 'normal 'local (kbd "<leader>-")   (lambda () (interactive) (agda2-goal-and-context-and-inferred 16)))
  (evil-define-key 'normal 'local (kbd "<leader><tab>")     'LaTeX-mode)

  ;; Enable snippets
  (yas-minor-mode)
  ;; Just expand snippets with cursor indentation instead of trying to be smart...
  (set (make-local-variable 'yas-indent-line) 'fixed)

  (setq company-dabbrev-downcase nil)
  (setq company-minimum-prefix-length 1)
  (setq company-backends '(
    (company-dabbrev :with company-yasnippet)
  ))
  (company-mode)


  ;; Count _ as part of a word.
  (modify-syntax-entry ?_ "w" rust-mode-syntax-table)
  (modify-syntax-entry ?/ "w")

  ;; (font-lock-add-keywords nil '(
  ;;   ("\\(--[ \t]*####[ \t]\\)\\([^\r\n]*\\)$"  (1 font-lock-comment-face) (2 custom-doc-h4-face))
  ;;   ("\\(--[ \t]*###[ \t]\\)\\([^\r\n]*\\)$"  (1 font-lock-comment-face) (2 custom-doc-h3-face))
  ;;   ("\\(--[ \t]*##[ \t]\\)\\([^\r\n]*\\)$"   (1 font-lock-comment-face) (2 custom-doc-h2-face))
  ;;   ("\\(--[ \t]*#[ \t]\\)\\([^\r\n]*\\)$"    (1 font-lock-comment-face) (2 custom-doc-h1-face))
  ;; ))

  (outline-minor-mode)
  (setq outline-regexp "[ \t]*-- [*\f]+")
  (evil-define-key 'normal 'local (kbd "zz")     'outline-cycle)

  ;; For some reason projectile ignores any kind of .gitignore file or
  ;; ignore-variable settings in my agda projects...
  ;; The only thing that works is switching to 'native indexing AND providing a
  ;; .projectile file...
  ;; FIXME: for some reason this line is ignored..............
  (setq-default projectile-indexing-method 'native)

  (require 'agda-input)
  (set-input-method "Agda")
  (add-hook 'evil-insert-state-entry-hook (lambda () (set-input-method "Agda")))
  (add-hook 'evil-insert-state-exit-hook (lambda () (set-input-method "Agda")))
  ;; (add-hook 'evil-insert-state-exit-hook (lambda () (set-input-method nil)))
))

;; Language: Markdown ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'markdown-mode)
  (package-install 'markdown-mode))
(require 'markdown-mode)

(add-hook 'markdown-mode-hook (lambda ()
  (evil-define-key 'normal 'local (kbd "<leader>p")   'markdown-preview)
  (evil-define-key 'normal 'local (kbd "<leader>P")   'markdown-live-preview-mode)
  (evil-define-key 'normal 'local (kbd "<leader>,")   'markdown-toggle-markup-hiding)
  (evil-define-key 'normal 'local (kbd "<leader>.")   'markdown-shifttab)
  (evil-define-key 'normal 'local (kbd "<leader>k")   'markdown-outline-previous)
  (evil-define-key 'normal 'local (kbd "<leader>j")   'markdown-outline-next)
  (evil-define-key 'normal 'local (kbd "<leader>h")   'markdown-outline-up)
))

;; TODO Settings and Keybindings

;; Language: Rust ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; comment to disable rustfmt on save
(setq rustic-format-on-save t)
(setq rustic-rustfmt-bin "rustfmt")

;; somehow doesn't do anything...
(setq lsp-rust-all-features t)
(setq lsp-rust-features "all")
;; at least without eglot (see also eglot in the hook)
(setq rustic-lsp-client 'eglot)

(unless (package-installed-p 'company)
  (package-install 'company))
(require 'company)

(unless (package-installed-p 'flycheck)
  (package-install 'flycheck))
(require 'flycheck)

(unless (package-installed-p 'lsp-mode)
  (package-install 'lsp-mode))
(require 'lsp-mode)

(unless (package-installed-p 'lsp-ui)
  (package-install 'lsp-ui))
(require 'lsp-ui)

(unless (package-installed-p 'rustic)
  (package-install 'rustic))
(require 'rustic)

;; what to use when checking on-save. "check" is default, I prefer clippy
;;(lsp-rust-analyzer-cargo-watch-command "clippy")
;;(setq lsp-eldoc-render-all t)
(setq lsp-idle-delay 0.6)
;;(setq lsp-rust-analyzer-server-display-inlay-hints t)
; (setq lsp-ui-doc-position 'bottom) ; Default: 'top
; (setq lsp-ui-doc-position 'at-point) ; Default: 'top
(setq lsp-ui-doc-max-height 26) ; Default: 13
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(setq lsp-ui-doc-show-with-cursor t)

(setq lsp-ui-peek-always-show t)
; (setq lsp-ui-sideline-show-hover t)
;;(setq lsp-ui-doc-enable nil)

;; Use eldoc buffer (if opened) instead of echo area.
;; This is used by eglot to display help for symbol at point.
(setq eldoc-echo-area-prefer-doc-buffer t)

(unless (package-installed-p 'eldoc-box)
  (package-install 'eldoc-box))
(require 'eldoc-box)

(unless (package-installed-p 'flycheck-eglot)
  (package-install 'flycheck-eglot))
(require 'flycheck-eglot)

(evil-define-key 'normal 'global (kbd "SPC E") 'eldoc-doc-buffer) 
(evil-define-key 'normal 'global (kbd "M-k") 'scroll-other-window-down) 
(evil-define-key 'normal 'global (kbd "M-j") 'scroll-other-window) 
(evil-define-key 'insert 'global (kbd "M-k") 'scroll-other-window-down) 
(evil-define-key 'insert 'global (kbd "M-j") 'scroll-other-window) 

(add-to-list 'eldoc-box-self-insert-command-list 'scroll-other-window)
(add-to-list 'eldoc-box-self-insert-command-list 'scroll-other-window-down)

(add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))

(add-hook 'rustic-mode-hook (lambda ()
  ;; Enable all cargo features
  (require 'eglot)
  (add-to-list 'eglot-server-programs
                 `(rust-mode . ("rust-analyzer" :initializationOptions
                                (:procMacro (:enable t)
                                 :cargo (:buildScripts (:enable t)
                                         :features "all")))))

  (global-flycheck-eglot-mode 1)

  (eldoc-box-hover-at-point-mode)

  (company-mode)

  (dolist (dir '("[/\\\\]\\.ccls-cache\\'"
                "[/\\\\]\\.mypy_cache\\'"
                "[/\\\\]\\.pytest_cache\\'"
                "[/\\\\]\\.cache\\'"
                "[/\\\\]\\.clwb\\'"
                "[/\\\\]__pycache__\\'"
                "[/\\\\]bazel-bin\\'"
                "[/\\\\]bazel-code\\'"
                "[/\\\\]bazel-genfiles\\'"
                "[/\\\\]bazel-out\\'"
                "[/\\\\]bazel-testlogs\\'"
                "[/\\\\]third_party\\'"
                "[/\\\\]third-party\\'"
                "[/\\\\]buildtools\\'"
                "[/\\\\]out\\'"
                "[/\\\\]build\\'"
                "[/\\\\]env\\'"
                "[/\\\\]target\\'"
                ))
      (push dir lsp-file-watch-ignored-directories))


  ; (evil-define-key 'normal 'local (kbd "<leader>a") 'lsp-execute-code-action) 
  ; (evil-define-key 'normal 'local (kbd "<leader>R") 'lsp-rename) 
  ; (evil-define-key 'normal 'local (kbd "<leader>r") 'lsp-ui-peek-find-references) 
  ; (evil-define-key 'normal 'local (kbd "<leader>d") 'lsp-ui-peek-find-definitions) 
  ; (evil-define-key 'normal 'local (kbd "<leader>g") 'lsp-find-definition) 
  ; (evil-define-key 'normal 'local (kbd "<leader>G") 'xref-pop-marker-stack) 

  (evil-define-key 'normal 'local (kbd "<leader>a") 'eglot-code-actions) 
  (evil-define-key 'normal 'local (kbd "<leader>A") 'eglot-code-action-quickfix) 
  (evil-define-key 'normal 'local (kbd "<leader>R") 'eglot-rename) 
  (evil-define-key 'normal 'local (kbd "<leader>r") 'xref-find-references) 
  ; (evil-define-key 'normal 'local (kbd "<leader>d") 'lsp-ui-peek-find-definitions) 
  (evil-define-key 'normal 'local (kbd "<leader>g") 'xref-find-definitions)
  (evil-define-key 'normal 'local (kbd "<leader>G") 'xref-pop-marker-stack) 
  (evil-define-key 'normal 'local (kbd "<leader>i") 'eglot-inlay-hints-mode)

  (show-paren-mode 1)

  ;; Count _ as part of a word.
  (modify-syntax-entry ?_ "w" rust-mode-syntax-table)

  ;; FIXME: Somehow doesn't update...
  (set-face-attribute 'font-lock-constant-face nil :foreground "#ffffff")
  (set-face-attribute 'font-lock-variable-name-face nil :foreground "#ffffff")

  (defface rust-custom-namespace-face
    '((t (:foreground "#9999cc" :height 1.0)))
    "Face to highlight parentheses."
    :group 'custom-faces)
  (defvar rust-custom-namespace-face 'rust-custom-namespace-face)

  (defface rust-custom-colon-face
    '((t (:foreground "#bbccff" :weight black)))
    "Face to highlight parentheses."
    :group 'custom-faces)
  (defvar rust-custom-colon-face 'rust-custom-colon-face)

  (defface rust-custom-macro-var-face
    '((t (:foreground "#ffffff" :weight black)))
    "Face to highlight parentheses."
    :group 'custom-faces)
  (defvar rust-custom-macro-var-face 'rust-custom-macro-var-face)

  (defface rust-custom-macro-use-face
    '((t (:foreground "#ffffff" :weight black)))
    "Face to highlight parentheses."
    :group 'custom-faces)
  (defvar rust-custom-macro-use-face 'rust-custom-macro-use-face)

  (modify-syntax-entry ?/ "w")

  (font-lock-add-keywords nil '(
    ;; ("\\([[:alnum:]]+::\\)" (1 rust-custom-namespace-face))
    ("\\(///[ \t]*####[ \t]\\)\\([^\r\n]*\\)$" (1 font-lock-comment-face) (2 custom-doc-h4-face))
    ("\\(///[ \t]*###[ \t]\\)\\([^\r\n]*\\)$" (1 font-lock-comment-face) (2 custom-doc-h3-face))
    ("\\(///[ \t]*##[ \t]\\)\\([^\r\n]*\\)$"  (1 font-lock-comment-face) (2 custom-doc-h2-face))
    ("\\(///[ \t]*#[ \t]\\)\\([^\r\n]*\\)$"   (1 font-lock-comment-face) (2 custom-doc-h1-face))
    ("\\(//[ \t]*####[ \t]\\)\\([^\r\n]*\\)$"  (1 font-lock-comment-face) (2 custom-doc-h4-face))
    ("\\(//[ \t]*###[ \t]\\)\\([^\r\n]*\\)$"  (1 font-lock-comment-face) (2 custom-doc-h3-face))
    ("\\(//[ \t]*##[ \t]\\)\\([^\r\n]*\\)$"   (1 font-lock-comment-face) (2 custom-doc-h2-face))
    ("\\(//[ \t]*#[ \t]\\)\\([^\r\n]*\\)$"    (1 font-lock-comment-face) (2 custom-doc-h1-face))
    ;; ("\\(///[ \t]*####[ \t][^\r\n]*\\)$" (1 custom-doc-h4-face))
    ;; ("\\(///[ \t]*###[ \t][^\r\n]*\\)$"  (1 custom-doc-h3-face))
    ;; ("\\(///[ \t]*##[ \t][^\r\n]*\\)$"   (1 custom-doc-h2-face))
    ;; ("\\(///[ \t]*#[ \t][^\r\n]*\\)$"    (1 custom-doc-h1-face))
    ;; ("\\(//[ \t]*####[ \t][^\r\n]*\\)$"  (1 custom-doc-h4-face))
    ;; ("\\(//[ \t]*###[ \t][^\r\n]*\\)$"   (1 custom-doc-h3-face))
    ;; ("\\(//[ \t]*##[ \t][^\r\n]*\\)$"    (1 custom-doc-h2-face))
    ;; ("\\(//[ \t]*#[ \t][^\r\n]*\\)$"     (1 custom-doc-h1-face))
    ("//[^\n]*$" . font-lock-comment-face)
    ("::"     . rust-custom-colon-face)
    ("\\."    . font-lock-keyword-face)
    (","      . font-lock-keyword-face)
    (";"      . font-lock-keyword-face)
    (":"      . font-lock-keyword-face)
    ("#!?\\[[^\n\r]*\\]" . custom-infix-face)
    ("#"      . custom-infix-face)
    ("\\?"    . font-lock-keyword-face)
    ("->"     . font-lock-keyword-face)
    ("=>"     . font-lock-keyword-face)
    ("<-"     . font-lock-keyword-face)
    ("<-"     . font-lock-keyword-face)
    ("|"      . font-lock-keyword-face)
    ;; ("|"      . custom-paren-face)
    ("&"      . custom-keyword-small-face)
    ("[^a-zA-Z0-9_]\\(mut\\|move\\|pub\\|static\\|macro_rules!\\)[^a-zA-Z0-9_]"  (1 font-lock-keyword-face))
    ("[^a-zA-Z0-9_]\\(self\\|Self\\|\\$crate\\)[^a-zA-Z0-9_]"  (1 font-lock-keyword-face))
    ("("      . custom-paren-face)
    (")"      . custom-paren-face)
    ("\\["    . custom-paren-face)
    ("\\]"    . custom-paren-face)
    ("{"      . custom-paren-face)
    ("}"      . custom-paren-face)
    ("<"      . custom-infix-face)
    (">"      . custom-infix-face)
    ("/"      . custom-infix-face)
    ("\\+"    . custom-infix-face)
    ("-"      . custom-infix-face)
    ("\\*"    . custom-infix-face)
    ("%"      . custom-infix-face)
    ("="      . custom-infix-face)
    ;; ("\\$"    . custom-infix-face)
    ("\\(\\$\\)(" (1 rust-custom-macro-use-face))
    ("\\$[a-zA-Z0-9_]+" . rust-custom-macro-var-face)
    ("[a-zA-Z0-9_]+!" . rust-custom-macro-use-face)
    ("!"      . custom-infix-face)
    ("[^a-zA-Z0-9_]\\(false\\|true\\)[^a-zA-Z0-9_]"  (1 'default))
    ("\\(enum\\|struct\\|const\\|type\\|macro_rules!\\)[ \t\n\r]+\\([^ \t\n\r:]+\\)" (2 font-lock-function-name-face))
  ))
))

;; Language: LaTeX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'auctex)
  (package-install 'auctex))
(require 'tex)

(set-default 'preview-scale-function 4.0)

(add-hook 'LaTeX-mode-hook (lambda ()
  (evil-define-key 'normal 'local (kbd "<leader>e") 'LaTeX-environment) 
  (evil-define-key 'normal 'local (kbd "<leader>m") 'TeX-master-file-ask)
  (evil-define-key 'normal 'local (kbd "<leader>r") 'TeX-command-run-all)
  (evil-define-key 'normal 'local (kbd "<leader>p") 'preview-buffer)
  (evil-define-key 'normal 'local (kbd "<leader>P") 'preview-clearout-buffer)
  (evil-define-key 'visual 'local (kbd "<leader>p") 'preview-region)
  (evil-define-key 'visual 'local (kbd "<leader>P") 'preview-clearout-region)
  (evil-define-key 'normal 'local (kbd ", <tab>") 'agda2-mode)

  (face-remap-add-relative 'font-lock-keyword-face '(:foreground "#bb55ff" :weight normal))
  ; (face-remap-add-relative 'font-lock-function-name-face '(:foreground "#bb55ff" :weight normal))
  (face-remap-add-relative 'font-lock-function-name-face '(:foreground "#ffffff" :weight normal))
  ; (setq-default tex-font-lock-keywords '())
  ; (setq-default tex-font-lock-keywords-1 '())
  ; (setq-default tex-font-lock-keywords-2 '())
  ; (setq-default tex-font-lock-keywords-3 '())

  (defface latex-custom-keyword-face
    '((t (:foreground "#60b0ff" :weight ultra-bold)))
    "Face to highlight keywords."
    :group 'custom-faces)
  (defvar latex-custom-keyword-face 'latex-custom-keyword-face)

  (defface latex-custom-command-face
    '((t (:foreground "#bb55ff")))
    "Face to highlight commands."
    :group 'custom-faces)
  (defvar latex-custom-command-face 'latex-custom-command-face)

  (defface latex-custom-math-face
    '((t (:background "#113311")))
    "Face to highlight commands."
    :group 'custom-faces)
  (defvar latex-custom-math-face 'latex-custom-math-face)

  (defface latex-custom-indent-face
    '((t (:background "#000000")))
    "Face to highlight commands."
    :group 'custom-faces)
  (defvar latex-custom-indent-face 'latex-custom-indent-face)

  (font-lock-add-keywords nil '(
    ; ("^ +" . latex-custom-indent-face)
    ; ("\\$\\$\\([^$]*\\)\\$\\$" (1 latex-custom-math-face))
    ; ("\\$\\([^$]*\\)\\$" (1 latex-custom-math-face))
    ("\\(\\\\\\)\\(\\\\\\)" (1 latex-custom-keyword-face) (2 latex-custom-command-face))
    ("\\(\\\\\\)\\([a-zA-Z]+\\)" (1 latex-custom-keyword-face) (2 latex-custom-command-face))
    ("\\\\" . latex-custom-keyword-face)
    ("\\ " . latex-custom-keyword-face)
    ("{" . latex-custom-keyword-face)
    ("}" . latex-custom-keyword-face)
    ("\\$" . latex-custom-keyword-face)
  ))
))

;; Web Programming ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'impatient-mode)
  (package-install 'impatient-mode))
(require 'impatient-mode)

;; Nix ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'nix-mode)
  (package-install 'nix-mode))
(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                  :major-modes '(nix-mode)
                  :server-id 'nix))

;; Zoning the fuck out ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'zone)
  (package-install 'zone))
(require 'zone)

;; Zone out after 2 minutes of idle.
;;(zone-when-idle 120)

(setq zone-programs [
  zone-pgm-putz-with-case        ; letters switching cases
  ;; zone-pgm-rat-race              ; falling letters with case switch
  ;; zone-pgm-martini-swan-dive     ; falling letters swith case switch and explosions
  ;; zone-pgm-five-oclock-swan-dive ; falling letters with explosions
  ;; zone-pgm-rotate                ; horizontally rotating lines

  ;; zone-pgm-dissolve
  ;; zone-pgm-whack-chars
  ;; zone-pgm-rotate-LR-lockstep
  ;; zone-pgm-rotate-RL-lockstep
  ;; zone-pgm-rotate-LR-variable
  ;; zone-pgm-rotate-RL-variable
  ;; zone-pgm-drip
  ;; zone-pgm-drip-fretfully
  ;; zone-pgm-paragraph-spaz
  ;; ; zone-pgm-jitter
  ;; ; zone-pgm-stress
  ;; ; zone-pgm-stress-destress
  ;; ; zone-pgm-random-life
])

;; ChatGPT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'chatgpt-shell)
  (package-install 'chatgpt-shell))
(require 'chatgpt-shell)

;; ;; From repo: https://github.com/xenodium/chatgpt-shell
;; (add-to-list 'load-path "~/.emacs.d/local/chatgpt-shell")
;; (require 'chatgpt-shell)

(defun open-chatgpt-shell ()
  (interactive)
  (if (get-buffer-window "*chatgpt*")
    (progn
      (select-window (get-buffer-window "*chatgpt*")))
    (progn
      (split-window-below)
      (balance-windows)
      (other-window 1)
      (chatgpt-shell))))

(evil-define-key 'normal  'global (kbd "SPC g g") 'open-chatgpt-shell)
(evil-define-key 'normal  'global (kbd "SPC g m") 'chatgpt-shell-swap-model-version)
(evil-define-key 'normal  'global (kbd "SPC g p") 'chatgpt-shell-swap-system-prompt)

;; Fonts ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defface custom-paren-face
  '((t (:foreground "#bbccff")))
  "Face to highlight parentheses."
  :group 'custom-faces)
(defvar custom-paren-face 'custom-paren-face)

(defface custom-infix-face
  '((t (:foreground "#bbccff")))
  "Face to highlight parentheses."
  :group 'custom-faces)
(defvar custom-infix-face 'custom-infix-face)

(defface custom-keyword-small-face
  '((t (:foreground "#60b0ff")))
  "Face to highlight parentheses."
  :group 'custom-faces)
(defvar custom-keyword-small-face 'custom-keyword-small-face)

(defface custom-pattern-face
  '((t (:foreground "#ff8844")))
  "Face to highlight parentheses."
  :group 'custom-faces)
(defvar custom-pattern-face 'custom-pattern-face)

(defface custom-doc-h1-face
  '((t (:inherit font-lock-doc-face :weight ultra-bold :height 2.4)))
  "Face to highlight parentheses."
  :group 'custom-faces)
(defvar custom-doc-h1-face 'custom-doc-h1-face)

(defface custom-doc-h2-face
  '((t (:inherit font-lock-doc-face :weight ultra-bold :height 2.1)))
  "Face to highlight parentheses."
  :group 'custom-faces)
(defvar custom-doc-h2-face 'custom-doc-h2-face)

(defface custom-doc-h3-face
  '((t (:inherit font-lock-doc-face :weight semi-bold :height 1.7)))
  "Face to highlight parentheses."
  :group 'custom-faces)
(defvar custom-doc-h3-face 'custom-doc-h3-face)

(defface custom-doc-h4-face
  '((t (:inherit font-lock-doc-face :weight semi-bold :height 1.4)))
  "Face to highlight parentheses."
  :group 'custom-faces)
(defvar custom-doc-h4-face 'custom-doc-h4-face)

;; left value: alpha for active window
;; right value: alpha for inactive window
;; (set-frame-parameter (selected-frame) 'alpha '(50 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (50 . 50)))

(set-frame-parameter nil 'alpha-background 50)
(add-to-list 'default-frame-alist '(alpha-background . 50))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000000" :foreground "#F8F8F2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 127 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(agda2-highlight-bound-variable-face ((t (:foreground "white"))))
 '(agda2-highlight-catchall-clause-face ((t nil)))
 '(agda2-highlight-coverage-problem-face ((t (:background "#663333"))))
 '(agda2-highlight-datatype-face ((t (:foreground "#99ff99"))))
 '(agda2-highlight-deadcode-face ((t (:background "#444444"))))
 '(agda2-highlight-function-face ((t (:foreground "#ae81ff"))))
 '(agda2-highlight-inductive-constructor-face ((t (:foreground "#99ff99"))))
 '(agda2-highlight-keyword-face ((t (:foreground "#60b0ff" :weight bold))))
 '(agda2-highlight-number-face ((t (:foreground "#99ff99"))))
 '(agda2-highlight-operator-face ((t (:foreground "#bbccff"))))
 '(agda2-highlight-positivity-problem-face ((t (:background "#663333"))))
 '(agda2-highlight-postulate-face ((t (:inherit nil :foreground "#ae81ff"))))
 '(agda2-highlight-primitive-face ((t (:foreground "#99ff99"))))
 '(agda2-highlight-primitive-type-face ((t (:foreground "#99ff99"))))
 '(agda2-highlight-record-face ((t (:foreground "#99ff99"))))
 '(agda2-highlight-symbol-face ((t (:foreground "#60b0ff"))))
 '(agda2-highlight-termination-problem-face ((t (:background "#663333"))))
 '(agda2-highlight-unsolved-constraint-face ((t (:background "#333300"))))
 '(agda2-highlight-unsolved-meta-face ((t (:background "#333300"))))
 '(company-coq-comment-h1-face ((t (:inherit font-lock-doc-face :weight ultra-bold :height 2.4))))
 '(company-coq-comment-h2-face ((t (:inherit font-lock-doc-face :weight ultra-bold :height 2.1))))
 '(company-coq-coqdoc-h1-face ((t (:inherit font-lock-doc-face :weight ultra-bold :height 2.4))))
 '(company-coq-coqdoc-h2-face ((t (:inherit font-lock-doc-face :weight ultra-bold :height 2.1))))
 '(company-coq-coqdoc-h3-face ((t (:inherit font-lock-doc-face :weight semi-bold :height 1.7))))
 '(company-coq-features/code-folding-bullet-face ((t (:inherit font-lock-keyword-face))))
 '(coq-button-face ((t (:foreground "#00b0ff" :weight ultra-bold))))
 '(coq-button-face-pressed ((t (:foreground "#80e0ff" :weight ultra-bold))))
 '(coq-solve-tactics-face ((t nil)))
 '(font-latex-bold-face ((t (:inherit bold))))
 '(font-latex-italic-face ((t (:inherit italic))))
 '(font-latex-math-face ((t nil)))
 '(font-latex-script-char-face ((t nil)))
 '(font-latex-sedate-face ((t (:foreground "#bb55ff"))))
 '(font-latex-verbatim-face ((t (:foreground "#99ff99" :inherit fixed-pitch))))
 '(font-latex-warning-face ((t (:foreground "#60b0ff"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#75715E"))))
 '(font-lock-comment-face ((t (:foreground "#75715E"))))
 '(font-lock-constant-face ((t (:foreground "#ffffff"))))
 '(font-lock-doc-face ((t (:foreground "#75715E"))))
 '(font-lock-function-name-face ((t (:foreground "#bb55ff" :weight black))))
 '(font-lock-keyword-face ((t (:foreground "#60b0ff" :weight ultra-bold))))
 '(font-lock-preprocessor-face ((t (:foreground "#bbccff"))))
 '(font-lock-string-face ((t (:foreground "#e8ff85"))))
 '(font-lock-type-face ((t (:foreground "#ffffff"))))
 '(font-lock-variable-name-face ((t (:foreground "#ffffff"))))
 '(fringe ((t (:background "#000000" :foreground "#F8F8F2"))))
 '(glsl-builtin-face ((t (:inherit font-lock-variable-face))))
 '(glsl-preprocessor-face ((t (:foreground "medium violet red"))))
 '(glsl-type-face ((t (:foreground "medium orchid"))))
 '(header-line ((t (:box nil :foreground "grey90" :background "black" :inherit mode-line))))
 '(hl-line ((t (:background "#111111"))))
 '(hl-todo ((t (:weight bold))))
 '(italic ((t (:slant italic))))
 '(line-number ((t (:background "#000000" :foreground "#555555"))))
 '(linum ((t (:background "#000000" :foreground "#555555"))))
 '(markdown-code-face ((t (:foreground "#bbccff"))))
 '(markdown-header-delimiter-face ((t (:foreground "#bbccff"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :foreground "#60b0ff" :weight ultra-bold :height 2.0))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :foreground "#60b0ff" :weight ultra-bold :height 1.6))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :foreground "#60b0ff" :weight semi-bold :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :foreground "#60b0ff" :weight semi-bold :height 1.1))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :foreground "#60b0ff" :weight semi-bold))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :foreground "#60b0ff" :slant italic))))
 '(markdown-inline-code-face ((t (:inherit markdown-code-face))))
 '(markdown-markup-face ((t (:foreground "#bbccff"))))
 '(markdown-markup-list-face ((t (:foreground "#bbccff"))))
 '(mode-line ((t (:background "#000000" :box nil))))
 '(mode-line-inactive ((t (:background "#000000" :box nil))))
 ;; '(mode-line ((t (:background "#000000" :box (:line-width 1 :color "#000000")))))
 ;; '(mode-line-inactive ((t (:background "#000000" :box (:line-width 1 :color "#000000")))))
 '(mode-line-buffer-id ((t (:foreground "#ffffff" :weight bold))))
 '(powerline-active0 ((t (:background "#071117"))))
 '(powerline-active1 ((t (:background "#071117"))))
 '(powerline-active2 ((t (:background "#071117"))))
 '(powerline-inactive0 ((t (:background "#070707"))))
 '(powerline-inactive1 ((t (:background "#070707"))))
 '(powerline-inactive2 ((t (:background "#070707"))))
 '(proof-locked-face ((t (:background "#203040"))))
 '(proof-queue-face ((t (:background "#406080"))))
 '(proof-tacticals-name-face ((t nil)))
 '(proof-tactics-name-face ((t nil)))
 '(rust-string-interpolation ((t (:foreground "#e8ff85" :weight bold))))
 '(show-paren-match ((t (:background "#203040" :foreground "#bbccff" :inverse-video nil :weight ultra-bold))))
 '(vertical-border ((t (:foreground "#111111")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(agda-input-user-translations `(("hr" "↪") ("hl" "↩") ("[=" "⊑") ("[" , "⊏") ("]=" "⊒") ("]" , "⊐")))
 '(ignored-local-variable-values '((eval turn-off-auto-fill)))
 '(package-selected-packages
   '(auctex default-text-scale which-key rustic lsp-ui helm-ls-git flycheck evil-escape company centered-cursor-mode)))
