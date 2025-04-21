(define-module (dotfiles home home)
  #:use-module (gnu home)
  #:use-module (dotfiles home services shells)
  #:use-module (dotfiles home services files)
  #:use-module (dotfiles home services xdg)
  #:use-module (dotfiles home users-services)
  #:use-module (dotfiles home users-packages)
)

(home-environment
 (packages
  (append
   user-packages
   (specifications->packages
    '("git" "tmux"))))
    
 (services
  (append
   shell-services
   file-services
   xdg-services
   %base-home-services)))
