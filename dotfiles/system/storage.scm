(define-module (dotfiles system storage)
  #:export (storage-configuration))

(define storage-configuration
  (list
   (file-systems (cons* (file-system
                        (mount-point "/")
                        (device (uuid "aded1eeb-5058-490e-a57d-e75096d54a62" 'ext4))
                        (type "ext4"))
                       %base-file-systems))
   (swap-devices (list (swap-space
                       (target (uuid "07d9cd3a-51e4-4631-9b0d-34c3be0fe039")))))))
