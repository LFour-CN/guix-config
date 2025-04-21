(define-module (dotfiles system system-packages)
  #:use-module (gnu packages)
  #:export (system-packages))

(define system-packages
  (append
   (list
    (specification->package "emacs")
    (specification->package "emacs-exwm")
    (specification->package "emacs-desktop-environment")
    (specification->package "nss-certs")
    font-jetbrains-mono
    font-wqy-microhei)
   %base-packages))
