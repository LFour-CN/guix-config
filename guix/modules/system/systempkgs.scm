(define-module (modules system systempkgs)
  #:use-module (gnu)
  #:export (my-system-packages))

(define my-system-packages
  (append (list
           (pkg "emacs")
           (pkg "emacs-exwm")
           (pkg "nss-certs")
           (pkg "xorg")
           (pkg "network-manager")
           (pkg "nvda") ; add nvda package
          )
          %base-packages))
