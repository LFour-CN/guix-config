(define-module (dotfiles system system-packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages desktop-managers)
  #:export (system-packages)
)

(define system-packages
  (append
   (list
      (specification->package "emacs")
      (specification->package "emacs-exwm")
      (specification->package "emacs-desktop-environment")
      (specification->package "nss-certs")
      (specification->package "font-jetbrains-mono")
      (specification->package "font-wqy-microhei")
      (specification->package "lightdm")
      (specification->package "firefox")
      (specification->package "nemo")
      (specification->package "neovim")
   )
   %base-packages))
