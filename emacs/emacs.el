(require 'package)
(add-to-list 'package-archives '("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/") t)
(add-to-list 'package-archives '("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

(setq inhibit-startup-message t)

;; Set up the visible bell
(setq visible-bell t)


(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)

;; 设置垃圾回收阈值，避免频繁的垃圾回收影响性能
(defun max-gc-limit ()
  (setq gc-cons-threshold most-positive-fixnum))
(defun reset-gc-limit ()
  (setq gc-cons-threshold 800000))
(add-hook 'minibuffer-setup-hook #'max-gc-limit)
(add-hook 'minibuffer-exit-hook #'reset-gc-limit)

(setq-default bidi-display-reordering nil)

;; 启用全局语法高亮模式
(global-font-lock-mode t)

;; 禁用菜单栏、工具栏和滚动条
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; 设置默认字体和字号
;;(set-face-attribute 'default nil :font "Maple Mono NF" :height 120)

;; 加载 uniquify 包，用于处理同名缓冲区
(require 'uniquify)

;; 启用自动配对括号模式
(electric-pair-mode t)

;; 启用括号匹配高亮显示模式
(show-paren-mode 1)

;; 设置默认缩进使用空格而非制表符
(setq-default indent-tabs-mode nil)

;; 启用保存光标位置模式
(save-place-mode t)

;; 启用历史记录保存模式
(savehist-mode t)

;; 编程模式下，可以折叠代码块
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; 启用最近文件列表模式
(recentf-mode t)

;; 在 Emacs 启动后执行的钩子函数
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; 恢复正常的垃圾回收阈值
            (setq gc-cons-threshold 100000000) ; 100 mb
            ;; 启用全局自动刷新模式
            (global-auto-revert-mode)
            ;; 在编程模式下启用行号显示
            (add-hook 'prog-mode-hook 'display-line-numbers-mode)))

;; 配置 uniquify 缓冲区命名风格
(setq uniquify-buffer-name-style 'forward
      window-resize-pixelwise t
      frame-resize-pixelwise t
      load-prefer-newer t
      backup-by-copying t
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      custom-file (expand-file-name "custom.el" user-emacs-directory))

;; 在编程模式下启用相对行号显示
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Some Packages ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; EXWM ;;;;;;;;;;;;;;;;;;;;;;

(use-package exwm
  :init
  :config
  ;; 使用 progn 将多个配置语句包裹起来
  (progn
    (setq exwm-workspace-show-all-buffers t)
    (setq exwm-layout-show-all-buffers t)
    (add-hook 'exwm-update-class-hook
              (lambda ()
                (exwm-workspace-rename-buffer exwm-class-name)))
    (with-eval-after-load 'evil
      (evil-set-initial-state 'exwm-mode 'motion))
    ;; do not forward anything besides keys defined with
    ;; `exwm-input-set-key' and `exwm-mode-map'
    (setq exwm-input-prefix-keys '())
    (exwm-enable)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;  EAF ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eaf
  :load-path "~/.emacs.d/site-lisp/emacs-application-framework"
  :custom
  ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
  (eaf-browser-continue-where-left-off t)
  (eaf-browser-enable-adblocker t)
  (browse-url-browser-function 'eaf-open-browser)
  :config
  (defalias 'browse-web #'eaf-open-browser)
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  (eaf-bind-key take_photo "p" eaf-camera-keybinding)
  (eaf-bind-key nil "M-q" eaf-browser-keybinding)) ;; unbind, see more in the Wiki

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; powerline ;;;;;;;;;;;;;;;;;

(use-package powerline
  :ensure t
  )
(powerline-default-theme)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; pyim ;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package pyim
  :ensure t
  :config
  (setq default-input-method "pyim")
  (setq pyim-page-tooltip 'posframe)
  (setq pyim-default-scheme 'quanpin)
  (global-set-key (kbd "C-\\") 'toggle-input-method))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 avy ;;;;;;;;;;;;;;;;;;;;;;;;

(use-package avy
  :bind (("C-'" . avy-goto-char-timer) ; Control + 单引号
         ;; 复用上一次搜索
         ("C-c C-j" . avy-resume))
  :config
  ;; 设置 avy 的配置项
  (setq avy-background t ; 打关键字时给匹配结果加一个灰背景，更醒目
        avy-all-windows t ; 搜索所有 window，即所有「可视范围」
        avy-timeout-seconds 0.3)) ; 「关键字输入完毕」信号的触发时间

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 multiple-cursors ;;;;;;;;;;;;;

(use-package multiple-cursors
  :bind (("C-S-c" . mc/edit-lines) ; 每行一个光标
         ("C->" . mc/mark-next-like-this-symbol) ; 全选光标所在单词并在下一个单词增加一个光标。通常用来启动一个流程
         ("C-M->" . mc/skip-to-next-like-this) ; 跳过当前单词并跳到下一个单词，和上面在同一个流程里。
         ("C-<" . mc/mark-previous-like-this-symbol) ; 同样是开启一个多光标流程，但是是「向上找」而不是向下找。
         ("C-M-<" . mc/skip-to-previous-like-this) ; 跳过当前单词并跳到上一个单词，和上面在同一个流程里。
         ("C-c C->" . mc/mark-all-symbols-like-this))) ; 直接多选本 buffer 所有这个单词

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置 vterm ;;;;;;;;;;;;;;;;;;;;;;;

(use-package vterm
  :ensure t
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 quickrun ;;;;;;;;;;;;;;;;;;;

(use-package quickrun
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'quickrun--mode 'emacs))
  (quickrun-add-command "c++/clang++"
    '((:exec . ("%c -std=c++14 -x c++ %o -o %e %s" "%e %a")))
    :override t)
  :bind ("C-c r" . quickrun))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 rainbow-delimiters ;;;;;;;;;;;

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 all-the-icons ;;;;;;;;;;;

(use-package all-the-icons
  :ensure t
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 sr-speedbar ;;;;;;;;;;;;;;;;;

(use-package sr-speedbar
  :custom
  ;; 设置 sr-speedbar 的配置项
  (speedbar-show-unknown-files t)
  (speedbar-enable-update t)
  (sr-speedbar-skip-other-window-p t)
  (sr-speedbar-auto-refresh t)
  :bind (("C-c s" . sr-speedbar-toggle)
         :map speedbar-mode-map
         ("a" . speedbar-toggle-show-all-files)
         ("l" . sr-speedbar-refresh-toggle)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 which-key ;;;;;;;;;;;;;;;;;

(use-package which-key
  :config
  ;; 启用 which-key 模式
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置 bing-dict ;;;;;;;;;;;;;;;;;

(use-package bing-dict
  :bind ("C-c l" . bing-dict-brief))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置 corfu ;;;;;;;;;;;;;;;;;;;;;

(use-package corfu
  :custom
  ;; 设置 corfu 的配置项
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-on-exact-match nil)
  (corfu-preview-current nil)
  :config
  ;; 启用全局 corfu 模式
  (global-corfu-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置 eglot ;;;;;;;;;;;;;;;;;;;;

(use-package eglot
  :custom
  ;; 设置 eglot 的配置项
  (eglot-autoreconnect nil)
  (eglot-autoshutdown t)
  :hook (python-mode . eglot-ensure)
  :bind (:map eglot-mode-map
         ("C-c C-e f" . eglot-format)
         ("C-c C-e i" . eglot-code-action-organize-imports)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置 deft ;;;;;;;;;;;;;;;;;;;;;

(use-package deft
  :custom
  ;; 设置 deft 的配置项
  (deft-directory org-directory)
  (deft-extensions '("org" "md" "tex"))
  (deft-default-extension "org")
  (deft-ignore-file-regexp "\\(?:index\\|readme\\|sitemap\\|archive\\)")
  (deft-recursive t)
  (deft-auto-save-interval 0)
  (deft-use-filename-as-title t)
  (deft-use-filter-string-for-filename t)
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'deft-mode 'emacs))
  :hook (deft-open-file . deft-filter-clear)
  :bind ("C-c d" . deft))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 markdown-mode ;;;;;;;;;;;

(use-package markdown-mode
  :mode ("\\.md\\'" "\\.markdown\\'")
  :custom
  ;; 设置 markdown-mode 的配置项
  (markdown-command "pandoc --quiet --mathjax --no-highlight -f markdown")
  (markdown-css-paths '("https://isaac.ttm.sh/org/css/md.css"))
  (markdown-xhtml-header-content "\n<meta name=\"viewport\" content=\"width=device-width\">\n<script src=\"https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/latest.js?config=TeX-MML-AM_CHTML\" async></script>"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; 配置 web-mode ;;;;;;;;;;;;;

(use-package web-mode
  :mode (("\\.html?$" . web-mode)
         ("\\.jsx?$" . web-mode)
         ("\\.php$" . web-mode)
         ("\\.s?css$" . web-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; 配置flycheck ;;;;;;;;;;;;;;

(use-package flycheck
  :ensure t
  :config
  (setq truncate-lines nil) ; 如果单行信息很长会自动换行
  :hook
  (prog-mode . flycheck-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; 配置 org-mode ;;;;;;;;;;;;;;;

(use-package org
  :ensure t
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置 vertico ;;;;;;;;;;;;;;;;;;

(use-package vertico
  :ensure t
  :custom
  ;; 设置 vertico 的配置项
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :init
  ;; 启用 vertico 模式
  (vertico-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 marginalia ;;;;;;;;;;;;;;

(use-package marginalia
  :after vertico
  :ensure t
  :init
  ;; 启用 marginalia 模式
  (marginalia-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 corfu ;;;;;;;;;;;;;;;;;;

(use-package corfu
  :ensure t
  :init
  ;; 启用全局 corfu 模式
  (global-corfu-mode)
  :custom
  ;; 设置 corfu 的配置项
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-auto-prefix 0)
  (completion-styles '(basic)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 helpful ;;;;;;;;;;;;;

(use-package helpful
  :ensure t
  :bind (("C-h f" . #'helpful-callable)
         ("C-h v" . #'helpful-variable)
         ("C-h k" . #'helpful-key)
         ("C-c C-d" . #'helpful-at-point)
         ("C-h F" . #'helpful-function)
         ("C-h C" . #'helpful-command)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 evil ;;;;;;;;;;;;;;;

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-nerd-commenter
  :after evil
  :bind (("M-;" . evilnc-comment-or-uncomment-lines)
         :map evil-normal-state-map
         ("SPC c SPC" . evilnc-comment-or-uncomment-lines)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 auctex ;;;;;;;;;;;;;;;;;;;;;

(use-package tex
  :ensure auctex
  :after latex
  :config
  ;; 添加 LaTeX 命令
  (add-to-list 'TeX-command-list '("Latexmk" "latexmk -xelatex -quiet %s" TeX-run-command nil t
                                   :help "Run latexmk"))
  ;; 添加 LaTeX 清理中间文件的后缀
  (add-to-list 'LaTeX-clean-intermediate-suffixes "\\.fdb_latexmk")
  (with-eval-after-load 'evil
    (evil-set-initial-state 'TeX-output-mode 'emacs))
  :hook ((LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . TeX-fold-mode))
  :custom
  ;; 设置 TeX 的配置项
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-clean-confirm nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 加载主题 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-tokyo-night t)
  (doom-themes-treemacs-config))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置 denote ;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package denote
  :ensure t
  :custom
  ;; 设置 denote 的配置项
  (denote-known-keywords '("emacs" "journal"))
  ;; This is the directory where your notes live.
  (denote-directory (expand-file-name "~/denote/"))
  :bind
  (("C-c n n" . denote)
   ("C-c n f" . denote-open-or-create)
   ("C-c n i" . denote-link)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 magit ;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :ensure t
  :bind (("C-c g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 breadcrumb ;;;;;;;;;;;;;;;;;;;;

(use-package breadcrumb
  :init
  ;; 启用 breadcrumb 模式
  (breadcrumb-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 paredit ;;;;;;;;;;;;;;;;;;;;;;

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode . enable-paredit-mode)
         (lisp-mode . enable-paredit-mode)
         (ielm-mode . enable-paredit-mode)
         (lisp-interaction-mode . enable-paredit-mode)
         (scheme-mode . enable-paredit-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 elixir-mode ;;;;;;;;;;;;;;;;;

(use-package elixir-mode
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 julia-mode ;;;;;;;;;;;;;;;;;;

(use-package julia-mode
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 lua-mode ;;;;;;;;;;;;;;;;;;;;

(use-package lua-mode
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 markdown-mode ;;;;;;;;;;;;;;

(use-package markdown-mode
  :ensure t
  :hook ((markdown-mode . visual-line-mode)
         (markdown-mode . flyspell-mode))
  :init
  ;; 设置 markdown 命令
  (setq markdown-command "multimarkdown"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 php-mode ;;;;;;;;;;;;;;;;;;;

(use-package php-mode
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 web-mode ;;;;;;;;;;;;;;;;;;;

(use-package web-mode
  :ensure t
  :mode (("\\.ts\\'" . web-mode)
         ("\\.js\\'" . web-mode)
         ("\\.mjs\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :custom
  ;; 设置 web-mode 的配置项
  (web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (web-mode-code-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-markup-indent-offset 2)
  (web-mode-enable-auto-quoting nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 rust-mode ;;;;;;;;;;;;;;;;;;

(use-package rust-mode
  :ensure t
  :functions dap-register-debug-template
  :bind
  ("C-c C-c" . rust-run)
  :hook
  (rust-mode . lsp-deferred)
  :config
  ;; debug
  (require 'dap-gdb-lldb)
  (dap-register-debug-template "Rust::LLDB Run Configuration"
                               (list :type "lldb"
				     :request "launch"
			             :name "rust-lldb::Run"
				     :gdbpath "rust-lldb"
				     :target nil
				     :cwd nil)))

(use-package cargo
  :ensure t
  :hook
  (rust-mode . cargo-minor-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; 配置 yaml-mode ;;;;;;;;;;;;;;;;;;

(use-package yaml-mode
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; 配置 python-mode ;;;;;;;;;;;;;;;;

(use-package python
  :defer t
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python3" . python-mode)
  :config
  ;; for debug
  (require 'dap-python))

(use-package lsp-pyright
  :ensure t
  :config
  :hook
  (python-mode . (lambda ()
		  (require 'lsp-pyright)
		  (lsp-deferred))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 treemacs ;;;;;;;;;;;;;;;;;;;;;;

(use-package treemacs
  :ensure t
  :defer t
  :config
  (treemacs-tag-follow-mode)
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ;; ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  (:map treemacs-mode-map
	("/" . treemacs-advanced-helpful-hydra)))

(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile))

(use-package lsp-treemacs
  :ensure t
  :after (treemacs lsp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 highlight-symbol ;;;;;;;;;;;;;;

(use-package highlight-symbol
  :ensure t
  :init (highlight-symbol-mode)
  :bind ("<f3>" . highlight-symbol)) ;; 按下 F3 键就可高亮当前符号

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 indent-guides ;;;;;;;;;;;;;;;;;

(add-hook 'prog-mode-hook
          #'(lambda ()
             (require 'highlight-indent-guides)
             (setq highlight-indent-guides-method 'character)
             (setq highlight-indent-guides-auto-enabled t)
             ;; 设置响应模式，当光标移动到引导线上时触发响应
             (setq highlight-indent-guides-responsive 'top)
             (highlight-indent-guides-mode)))

(custom-set-faces
 '(highlight-indent-guides-character-face ((t (:foreground "blue")))))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(defun adjust-languages-indent (n)
  (setq-local c-basic-offset n)

  (setq-local coffee-tab-width n)
  (setq-local javascript-indent-level n)
  (setq-local js-indent-level n)
  (setq-local js2-basic-offset n)

  (setq-local web-mode-attr-indent-offset n)
  (setq-local web-mode-attr-value-indent-offset n)
  (setq-local web-mode-code-indent-offset n)
  (setq-local web-mode-css-indent-offset n)
  (setq-local web-mode-markup-indent-offset n)
  (setq-local web-mode-sql-indent-offset n)

  (setq-local css-indent-offset n))

(dolist (hook (list
               'c-mode-hook
               'c++-mode-hook
               'java-mode-hook
               'haskell-mode-hook
               'asm-mode-hook
               'sh-mode-hook
               'haskell-cabal-mode-hook
               'ruby-mode-hook
               'qml-mode-hook
               'scss-mode-hook
               'coffee-mode-hook
               ))
  (add-hook hook #'(lambda ()
                     (setq indent-tabs-mode nil)
                     (adjust-languages-indent 4)
                     )))

(dolist (hook (list
               'web-mode-hook
               'js-mode-hook
               ))
  (add-hook hook #'(lambda ()
                     (setq indent-tabs-mode nil)
                     (adjust-languages-indent 2)
                     )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 dashboard ;;;;;;;;;;;;;;;;;;;

 (use-package dashboard
  :ensure t
  :config
  (setq dashboard-banner-logo-title "Welcome to Emacs!") ;; 个性签名，随读者喜好设置
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-startup-banner 'official) ;; 也可以自定义图片
  (setq dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (projects  . 5)))
  (dashboard-setup-startup-hook))

;; Content is not centered by default. To center, set
(setq dashboard-center-content t)
;; Vertically center content
(setq dashboard-vertically-center-content t)
;; Disable shortcut "jump" indicators for each section
(setq dashboard-show-shortcuts nil)
;; Enable cycle navigation between each section
(setq dashboard-navigation-cycle t)
;; Customize string format in shortcuts
(setq dashboard-heading-shorcut-format " [%s]")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 company-mode ;;;;;;;;;;;;;;;;

(add-hook 'after-init-hook 'global-company-mode)
(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length 1) ; 只需敲 1 个字母就开始进行自动补全
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 0.0)
  (setq company-show-numbers t) ;; 给选项编号 (按快捷键 M-1、M-2 等等来进行选择).
  (setq company-selection-wrap-around t)
  (setq company-transformers '(company-sort-by-occurrence))) ; 根据选择的频率进行排序
(use-package company-box
  :ensure t
  :if window-system
  :hook (company-mode . company-box-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; 配置 yasnippet ;;;;;;;;;;;;;;;;

(use-package yasnippet
  :ensure t
  :hook
  (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all)
  ;; add company-yasnippet to company-backends
  (defun company-mode/backend-with-yas (backend)
    (if (and (listp backend) (member 'company-yasnippet backend))
	backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))
  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
  ;; unbind <TAB> completion
  (define-key yas-minor-mode-map [(tab)]        nil)
  (define-key yas-minor-mode-map (kbd "TAB")    nil)
  (define-key yas-minor-mode-map (kbd "<tab>")  nil)
  :bind
  (:map yas-minor-mode-map ("S-<tab>" . yas-expand)))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 dap-mode ;;;;;;;;;;;;;;;;;;;;

(use-package dap-mode
  :ensure t
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 projectile ;;;;;;;;;;;;;;;;;;

(use-package projectile
  :ensure t
  :bind (("C-c p" . projectile-command-map))
  :config
  (setq projectile-mode-line "Projectile")
  (setq projectile-track-known-projects-automatically nil))

(use-package counsel-projectile
  :ensure t
  :after (projectile)
  :init (counsel-projectile-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置快捷键 ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "<f4>") 'eshell)

(global-set-key (kbd "<f2>") 'counsel-find-file)

(global-set-key (kbd "<f12>") 'eww)

(global-set-key (kbd "<f3>") 'compile)

(global-set-key (kbd "C-c t") 'shell)

;; 定义向上跳转函数
(defun my-shift-up ()
  (interactive)
  (previous-line 20))

;; 定义向下跳转函数
(defun my-shift-down ()
  (interactive)
  (next-line 20))

;; 取消可能存在的冲突绑定
(global-unset-key (kbd "<S-k>"))
(global-unset-key (kbd "<S-j>"))

;; 绑定按键
(global-set-key (kbd "<S-up>") 'my-shift-up)
(global-set-key (kbd "<S-down>") 'my-shift-down)

(global-set-key (kbd "<S-k>") 'my-shift-up)
(global-set-key (kbd "<S-j>") 'my-shift-down)

;; 文本展开
(global-set-key (kbd "M-/") 'hippie-expand)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

