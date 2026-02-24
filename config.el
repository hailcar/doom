;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.




(after! lsp-mode
  ;; 告诉 lsp-mode 使用 basedpyright
  ;; Doom 的 python 模块通常使用 lsp-pyright 插件
  ;; 核心：开启额外文本编辑支持（自动导入的关键）
  (setq lsp-enable-snippet nil)
  (setq lsp-completion-enable-additional-text-edit t))

(after! lsp-pyright
  ;; 开启基于 basedpyright 的自动导入建议
  (setq lsp-pyright-auto-import-completions t)

  ;; 推荐配置：basedpyright 的增强功能
  (setq lsp-pyright-typechecking-mode "basic") ;; 可选 "standard" 获取更严格的检查
  (setq lsp-pyright-auto-search-paths t)       ;; 自动搜索项目路径
  (setq lsp-pyright-use-library-code-for-types t)) ;; 使用库代码生成类型提示kkkkkkkkkk

;; 使用 key-chord 或者 evil 自带的设置
(setq evil-escape-key-sequence "fd")
(setq evil-escape-delay 0.23) ; 设置连按的时间间隔


(after! lsp-java
  ;; 开启 Gradle 项目自动导入
  (setq lsp-java-import-gradle-enabled t)
  ;; 如果你的 Gradle 很大，可以增加内存限制
  (setq lsp-java-vmargs
        '("-Xmx2G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication"))
  ;; 自动构建项目
  (setq lsp-java-autobuild-enabled t))

;; 优化 Company 后端配置，解决 Marker 错误
(after! company
  (setq company-backends
        '((company-capf :with company-yasnippet) ; 尝试使用 :with 代替 :separate
          company-files
          company-keywords))

  ;; 针对 asyncio 或异步补全的健壮性修复
  (defun my-fix-company-marker-error (candidates)
    "如果 candidate 为空，确保不触发后续可能导致 Marker 报错的动作。"
    (if (null candidates)
        nil
      candidates))

  ;; 建议在 post-completion 阶段增加保护检查
  (advice-add 'company--post-completion :before
              (lambda (&rest _)
                (unless (marker-position (point-marker))
                  (message "Company: 拦截到无效标记点，防止崩溃"))))
)
