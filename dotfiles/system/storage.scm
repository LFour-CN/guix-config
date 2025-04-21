(define-module (dotfiles system storage)
  #:export (storage-configuration))

(define storage-configuration
  (list
   (file-systems (cons* (file-system
                        (mount-point "/")
                        (device (uuid "6f307dc0-e816-4d9f-9490-b2a04335974" 'ext4))
                        (type "ext4"))
                       %base-file-systems))
   (swap-devices (list (swap-space
                       (target (uuid "87d82d45-6301-48f9-96aa-3a97fe89ab59")))))))
