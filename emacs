;; Initialize package sources
(require 'package)
(setq package-archives
      '(("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("gnu-devel" . "https://elpa.gnu.org/devel/")
        ("elpa" . "https://elpa.gnu.org/packages/")
        ("nongnu-devel" . "https://elpa.nongnu.org/nongnu-devel/")))
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
  
;; EXWM
(use-package 'exwm
  :ensure t
  )
(use-package 'exwm-config
  :ensure t
  )
(exwm-config-default)

(use-package  'exwm-systemtray
  :ensure t
)
(exwm-systemtray-mode 1)

(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)

;; powerline
(use-package 'powerline
  :ensure t
  )
(powerline-default-theme)

;; pyim
(use-package 'pyim
  :ensure t
  :config
  (setq default-input-method "pyim")
  (setq pyim-page-tooltip 'posframe)
  (setq pyim-default-scheme 'quanpin)
  (global-set-key (kbd "C-\\") 'toggle-input-method))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Some Packages ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;; 配置 ivy 和 swiper ;;;;;;;;;;;;;;;;;;;

(use-package counsel
  :ensure t
  )

(use-package ivy
  :ensure t
  :init
  (ivy-mode 1)
  (counsel-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq search-default-mode #'char-fold-to-regexp)
  (setq ivy-count-format "(%d/%d) ")
  :bind
  (("C-s" . 'swiper)
   ("C-x b" . 'ivy-switch-buffer)
   ("C-c v" . 'ivy-push-view)
   ("C-c s" . 'ivy-switch-view)
   ("C-c V" . 'ivy-pop-view)
   ("C-x C-@" . 'counsel-mark-ring); 在某些终端上 C-x C-SPC 会被映射为 C-x C-@，比如在 macOS 上，所以要手动设置
   ("C-x C-SPC" . 'counsel-mark-ring)
   :map minibuffer-local-map
   ("C-r" . counsel-minibuffer-history)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 undo-tree ;;;;;;;;;;;;;;;;;;;;;

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode)
  :custom
  (undo-tree-auto-save-history nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 good-scroll ;;;;;;;;;;;;;;;;;;;

(use-package good-scroll
  :ensure t
  :if window-system
  :init (good-scroll-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 mwin ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package mwim
  :ensure t
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; 配置 ace-window ;;;;;;;;;;;;;;;;;;;;

(use-package ace-window
  :ensure t
  :bind (("C-x o" . 'ace-window)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; 配置 amx ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package amx
  :defer 1
  :config
  ;; 启用 amx 模式
  (amx-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 配置 treesit 语言源列表 ;;;;;;;;;;;;;;;;;;

(setq treesit-language-source-alist
      '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
        (c . ("https://github.com/tree-sitter/tree-sitter-c"))
        (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
        (css . ("https://github.com/tree-sitter/tree-sitter-css"))
        (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
        (csharp . ("https://github.com/tree-sitter/tree-sitter-c-sharp.git"))
        (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
        (elisp . ("https://github.com/Wilfred/tree-sitter-elisp"))
        (go . ("https://github.com/tree-sitter/tree-sitter-go"))
        (gomod . ("https://github.com/camdencheek/tree-sitter-go-mod.git"))
        (html . ("https://github.com/tree-sitter/tree-sitter-html"))
        (java . ("https://github.com/tree-sitter/tree-sitter-java.git"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
        (json . ("https://github.com/tree-sitter/tree-sitter-json"))
        (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
        (make . ("https://github.com/alemuller/tree-sitter-make"))
        (markdown . ("https://github.com/MDeiml/tree-sitter-markdown" nil "tree-sitter-markdown/src"))
        (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" nil "ocaml/src"))
        (org . ("https://github.com/milisims/tree-sitter-org"))
        (python . ("https://github.com/tree-sitter/tree-sitter-python"))
        (php . ("https://github.com/tree-sitter/tree-sitter-php"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
        (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src"))
        (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
        (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
        (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
        (vue . ("https://github.com/merico-dev/tree-sitter-vue"))
        (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))
        (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
        (zig . ("https://github.com/GrayJack/tree-sitter-zig"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置括号匹配高亮显示 ;;;;;;;;;;;;

(use-package paren
  :custom-face (show-paren-match ((t (:foreground "SpringGreen3" :underline t :weight bold))))
  :config
  ;; 设置括号匹配显示的条件和延迟
  (setq show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t
        show-paren-context-when-offscreen t
        show-paren-delay 0.2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置当前行高亮显示 ;;;;;;;;;;;;;;;

(use-package hl-line
  :hook (after-init . global-hl-line-mode)
  :config
  ;; 设置当前行高亮不粘连
  (setq hl-line-sticky-flag nil)
  ;; 设置高亮范围从行尾开始
  (setq hl-line-range-function (lambda () (cons (line-end-position)
                                                (line-beginning-position 2)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 magit ;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :commands (magit-status magit-blame magit-status-fullscreen magit-dispatch magit-checkout)
  :init
  ;; 加载 dash 包
  (use-package dash)
  :custom
  ;; 设置 magit 显示缓冲区的方式
  (magit-display-buffer-function #'magit-display-buffer-fullcolumn-most-v1)
  :config
  ;; 在 magit 模式下禁用 whitespace 模式
  (add-hook 'magit-mode-hook (lambda ()
                               (setq whitespace-mode nil)
                               ;; 强制 magit-status 缓冲区垂直打开
                               ;; (setq split-width-threshold 0)
                               ;; (setq split-height-threshold nil)
                               )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; 配置 emmet-mode ;;;;;;;;;;;;;;

(use-package emmet-mode
  :commands (emmet-mode emmet-expand-line yas/insert-snippet yas-insert-snippet company-complete)
  :hook ((sgml-mode css-mode web-mode) . emmet-mode)
  :config
  ;; 设置 emmet 模式的配置项
  (setq emmet-move-cursor-between-quotes t)
  (setq emmet-indent-after-insert nil)
  ;; 解绑 emmet 模式的快捷键
  (unbind-key "C-M-<left>" emmet-mode-keymap)
  (unbind-key "C-M-<right>" emmet-mode-keymap)
  :bind
  ("C-j" . emmet-expand-line)
  ((:map emmet-mode-keymap
         ("C-c [" . emmet-prev-edit-point)
         ("C-c ]" . emmet-next-edit-point))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; 配置 helm-projectile ;;;;;;;;;;;

;;(use-package helm-projectile
;;  :if (functionp 'helm) ; 如果使用了 helm 的话，让 projectile 的选项菜单使用 Helm 呈现
;;  :config
;;  ;; 启用 helm-projectile
;;  (helm-projectile-on))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; 配置 LSP ;;;;;;;;;;;;;;;;;;

(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l"
	lsp-file-watch-threshold 500)
  :hook 
  (lsp-mode . lsp-enable-which-key-integration) ; which-key integration
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-completion-provider :none) ;; 阻止 lsp 重新设置 company-backend 而覆盖我们 yasnippet 的设置
  (setq lsp-headerline-breadcrumb-enable t)
  :bind
  ("C-c l s" . lsp-ivy-workspace-symbol)) ;; 可快速搜索工作区内的符号（类名、函数名、变量名等）

(use-package lsp-ui
  :ensure t
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-doc-position 'top))

(use-package lsp-ivy
  :ensure t
  :after (lsp-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; 配置 helm-swoop ;;;;;;;;;;;;;;;;;

(use-package helm-swoop
  ;; 更多关于它的配置方法: https://github.com/ShingoFukuyama/helm-swoop
  ;; 以下我的配置仅供参考
  :bind
  (("M-i" . helm-swoop)
   ("M-I" . helm-swoop-back-to-last-point)
   ("C-c M-i" . helm-multi-swoop)
   ("C-x M-i" . helm-multi-swoop-all)
   :map isearch-mode-map
   ("M-i" . helm-swoop-from-isearch)
   :map helm-swoop-map
   ("M-i" . helm-multi-swoop-all-from-helm-swoop)
   ("M-m" . helm-multi-swoop-current-mode-from-helm-swoop))
  :config
  ;; 它像 helm-ag 一样，可以直接修改搜索结果 buffer 里的内容并 apply
  (setq helm-multi-swoop-edit-save t)
  ;; 如何给它新开分割窗口
  ;; If this value is t, split window inside the current window
  (setq helm-swoop-split-with-multiple-windows t))

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
  :commands vterm
  :bind ((:map vterm-mode-map
               ("C-y" . vterm-yank)
               ("M-y" . vterm-yank-pop)
               ("C-q" . vterm-send-next-key)
               ("C-z" . nil)
               ("M-:" . nil)))
  :custom
  ;; 设置 vterm 的配置项
  (vterm-kill-buffer-on-exit t)
  (vterm-max-scrollback 10000)
  (vterm-buffer-name-string "vterm %s"))

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
;;;;;;;;;;;; 配置包仓库 ;;;;;;;;;;;;;;;;

;;(setq package-archives
;;      '(("gnu" . "https://mirrors.163.com/elpa/gnu/")
;;        ("melpa" . "https://mirrors.163.com/elpa/melpa/")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; 配置 flymake ;;;;;;;;;;;;;;

(use-package flymake
  :hook (prog-mode . flymake-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; 配置flycheck ;;;;;;;;;;;;;;

(use-package flycheck
  :ensure t
  :config
  (setq truncate-lines nil) ; 如果单行信息很长会自动换行
  :hook
  (prog-mode . flycheck-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; 配置 org 模式 ;;;;;;;;;;;;;;;

;; 基本路径和变量设置
(setq org-directory (file-truename "~/org/"))
(setq pv/org-agenda-files `(,(concat org-directory "Agenda/")))
;;(setq pv/org-refile-file (concat org-directory "refile.org"))
(setq pv/org-bibtex-library `(,(concat org-directory "References/")))
(setq pv/org-bibtex-files `(,(concat org-directory "References/references.bib")))

;; 加载org-mode相关配置
(use-package org
  :init
  (require 'org-indent)
  :config
  ;; 初始化钩子函数
  (defun pv/init-org-hook ()
    (setq truncate-lines nil)
    (org-toggle-pretty-entities)) ; 显示LaTeX符号
  ;; 跳过指定优先级子树的函数
  (defun pv/org-skip-subtree-if-priority (priority)
    "如果议程子树的优先级为PRIORITY，则跳过该子树。
PRIORITY可以是字符?A、?B或?C之一。"
    (let ((subtree-end (save-excursion (org-end-of-subtree t)))
          (pri-value (* 1000 (- org-lowest-priority priority)))
          (pri-current (org-get-priority (thing-at-point 'line t))))
      (if (= pri-value pri-current)
          subtree-end
        nil)))
  ;; 跳过习惯相关子树的函数
  (defun pv/org-skip-subtree-if-habit ()
    "如果议程条目具有等于“habit”的STYLE属性，则跳过该条目。"
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (if (string= (org-entry-get nil "STYLE") "habit")
          subtree-end
        nil)))
  :hook
  (org-mode . pv/init-org-hook)
  :custom
  ;; 显示相关设置
  (org-hide-leading-stars t "更清晰的显示方式")
  (org-startup-with-inline-images t "始终显示内联图像")
  (org-image-actual-width 600 "设置显示图像时的宽度")
  (org-outline-path-complete-in-steps nil)
  ;; 待办事项相关设置
  (org-todo-keywords
   (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
           (sequence "WAITING(w@/!)" "|" "CANCELLED(c@/!)" "MEETING"))))
  (org-todo-keyword-faces
   (quote (("TODO" :foreground "goldenrod1" :weight bold)
           ("NEXT" :foreground "DodgerBlue1" :weight bold)
           ("DONE" :foreground "SpringGreen2" :weight bold)
           ("WAITING" :foreground "LightSalmon1" :weight bold)
           ("CANCELLED" :foreground "LavenderBlush4" :weight bold)
           ("MEETING" :foreground "IndianRed1" :weight bold))))
  (org-todo-state-tags-triggers
   (quote (("CANCELLED" ("CANCELLED" . t))
           ("WAITING" ("WAITING" . t))
           (done ("WAITING"))
           ("TODO" ("WAITING") ("CANCELLED"))
           ("NEXT" ("WAITING") ("CANCELLED"))
           ("DONE" ("WAITING") ("CANCELLED")))))
  (org-adapt-indentation t)
  ;; 议程相关设置
  (org-agenda-files pv/org-agenda-files)
  (org-agenda-dim-blocked-tasks nil)
  (org-agenda-compact-blocks t)
  (org-agenda-span 7)
  (org-agenda-start-day "-2d")
  (org-agenda-start-on-weekday nil)
  (org-agenda-tags-column -86) ; 默认值自动设置有问题
  ;; 自定义议程命令定义
  (org-agenda-custom-commands
   (quote (("d" "每日议程和所有待办事项"
            ((tags "PRIORITY=\"A\""
                   ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                    (org-agenda-overriding-header "高优先级未完成任务:")))
             (agenda "" ((org-agenda-ndays 1)))
             (alltodo ""
                      ((org-agenda-skip-function '(or (pv/org-skip-subtree-if-habit)
                                                      (pv/org-skip-subtree-if-priority ?A)
                                                      (org-agenda-skip-if nil '(scheduled deadline))))
                       (org-agenda-overriding-header "所有普通优先级任务:"))))
            ((org-agenda-compact-blocks t)))
           ("p" "项目"
            ((agenda "" nil)
             (tags "REFILE"
                   ((org-agenda-overriding-header "待重新归档的任务")
                    (org-tags-match-list-sublevels nil)))
             (tags-todo "-CANCELLED/!"
                        ((org-agenda-overriding-header "停滞项目")
                         (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                         (org-agenda-sorting-strategy
                          '(category-keep))))
             (tags-todo "-CANCELLED/!NEXT"
                        ((org-agenda-overriding-header (concat "项目下一步任务"
                                                               (if bh/hide-scheduled-and-waiting-next-tasks
                                                                   ""
                                                                   " (包括WAITING和SCHEDULED任务)")))
                         (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                         (org-tags-match-list-sublevels t)
                         (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                         (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                         (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                         (org-agenda-sorting-strategy
                          '(todo-state-down effort-up category-keep))))
             (tags "-REFILE/"
                   ((org-agenda-overriding-header "待归档任务")
                    (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                    (org-tags-match-list-sublevels nil))))
            nil))))
  :bind
  (("C-c a" . 'org-agenda)
   ("C-c c" . 'org-capture)
   :map org-mode-map
   ("C-c C-q" . counsel-org-tag)))

;; org-roam配置
(use-package org-roam
   :ensure t
   :after org
   :init
   (setq org-roam-v2-ack t) ;; Acknowledge V2 upgrade
   :config
   (org-roam-setup)
   :custom
   (org-roam-directory (concat org-directory "roam/")) ; 设置 org-roam 目录
   :bind
   (("C-c n f" . org-roam-node-find)
    (:map org-mode-map
          (("C-c n i" . org-roam-node-insert)
           ("C-c n o" . org-id-get-create)
           ("C-c n t" . org-roam-tag-add)
           ("C-c n a" . org-roam-alias-add)
           ("C-c n l" . org-roam-buffer-toggle)))))

;; bibtex-completion配置
(use-package bibtex-completion
  :custom
  (bibtex-completion-pdf-open-function
   (lambda (fpath)
     (call-process "open" nil 0 nil fpath))) ; 配置打开PDF的方式
  (bibtex-completion-bibliography pv/org-bibtex-files)
  (bibtex-completion-library-path pv/org-bibtex-library))

;; org-ref配置
;;(use-package org-ref
;;  :ensure t)

;; org-mode捕获和引用相关配置
;;(use-package org
;;  :custom
;;  (org-capture-templates
;;   (quote (("t" "todo" entry (file pv/org-refile-file)
;;            "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
;;           ("r" "respond" entry (file pv/org-refile-file)
;;            "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
;;           ("n" "note" entry (file pv/org-refile-file)
;;            "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
;;           ("w" "org-protocol" entry (file pv/org-refile-file)
;;            "* TODO Review %c\n%U\n" :immediate-finish t)
;;           ("m" "Meeting" entry (file pv/org-refile-file)
;;            "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t))))
;;  (org-refile-targets (quote ((nil :maxlevel . 9)
;;                             (org-agenda-files :maxlevel . 9))))
;;  ;; 使用完整的大纲路径作为重新归档目标 - 我们直接使用IDO进行归档
;;  (org-refile-use-outline-path 'file)
;;  ;; 允许重新归档时确认创建父任务
;;  (org-refile-allow-creating-parent-nodes (quote confirm))
;;  (org-cite-global-bibliography pv/org-bibtex-files))

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
;;;;;;; 配置 eglot ;;;;;;;;;;;;;;;;

(use-package eglot
  :ensure t
  :bind (("s-<mouse-1>" . eglot-find-implementation)
         ("C-c ." . eglot-code-action-quickfix))
  :hook ((web-mode . eglot-ensure)
         (rust-mode . eglot-ensure))
  :config
  ;; 添加 eglot 服务器程序
  (add-to-list 'eglot-server-programs
               '(web-mode . ("typescript-language-server" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; 配置 evil-nerd-commenter ;;;;;;;;;;;

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

;;(unless (package-installed-p 'exotica-theme)
;;  (package-refresh-contents)
;;  (package-install 'exotica-theme))
;;(load-theme 'exotica t)

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
  :vc (:fetcher github :repo joaotavora/breadcrumb)
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
;;;;;;; 配置 C-mode ;;;;;;;;;;;;;;;;;;;;;;

(use-package c++-mode
  :functions 			; suppress warnings
  c-toggle-hungry-state
  :hook
  (c-mode . lsp-deferred)
  (c++-mode . lsp-deferred)
  (c++-mode . c-toggle-hungry-state))

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
;;;;;;;; 配置 lldb-dap ;;;;;;;;;;;;;;;;;;;;;

(use-package dap-lldb
  :after dap-mode
  :custom
  (dap-lldb-debug-program '("/usr/local/opt/llvm/bin/lldb-vscode"))
  ;; ask user for executable to debug if not specified explicitly (c++)
  (dap-lldb-debugged-program-function
    (lambda () (read-file-name "Select file to debug: "))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

