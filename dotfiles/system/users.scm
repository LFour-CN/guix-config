(define-module (dotfiles system users)
  #:export (users-configuration))

(define users-configuration
  (cons* (user-account
          (name "guix")
          (comment "Guix")
          (group "users")
          (home-directory "/home/guix")
          (supplementary-groups 
           '("wheel" "netdev" "audio" "video")))
         %base-user-accounts))
