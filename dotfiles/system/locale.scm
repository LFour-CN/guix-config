(define-module (dotfiles system locale)
  #:export (locale-configuration))

(define locale-configuration
  (list
   (locale "en_US.utf8")
   (timezone "Asia/Shanghai")
   (keyboard-layout (keyboard-layout "us"))))
