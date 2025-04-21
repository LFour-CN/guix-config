(define-module (dotfiles home services desktop)
  #:use-module (gnu home services)
  #:use-module (gnu home services xdg)
  #:use-module (gnu home services shells)
  #:export (file-services )
  #:export (xdg-services)
  #:export (shell-services)
)

(define file-services
  (list
   (service home-files-service-type
            `((".guile" ,(local-file "dotfiles/home/files/guile"))
              (".nanorc" ,(local-file "dotfiles/home/files/nanorc"))))))
              
(define xdg-services
  (list
   (service home-xdg-configuration-files-service-type
            `(("gdb/gdbinit" ,(local-file "dotfiles/home/files/gdbinit"))
              ("git/config"  ,(local-file "dotfiles/home/files/gitconfig"))))))




(define shell-services
  (list
   ;;(service home-bash-service-type)    ; Bash
   (service home-fish-service-type)   ; Fish
   ;;(service home-zsh-service-type)    ; Zsh
   ))
