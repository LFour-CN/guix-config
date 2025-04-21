(define-module (dotfiles system hardware)
  #:use-module (nongnu packages linux)
  #:export (hardware-configuration))

(define hardware-configuration
  (list
   (kernel linux) ; use unfree linux kernel
   ;; amd microcode
   ;(initrd (microcode-initrd (list (specification->package "amd-microcode"))))
   ;(firmware (cons* linux-firmware %base-firmware))
   ))
