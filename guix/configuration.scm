;; Guix configuration --- LFour-CN@github
;; Created time : 2025-4-15
(use-modules (gnu)
             (gnu services)
             (gnu services guix)
             (gnu packages)
             (srfi srfi-1)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (nongnu packages nvidia)  ; NVIDIA packgae module
             (nongnu services nvidia) ; NVIDIA service module
             (modules system channels)
             (modules system systempkgs)
             (modules user usepkgs))

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "Asia/Shanghai")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "guix")

  (users (cons* (user-account
                 (name "guix")
                 (comment "Guix")
                 (group "users")
                 (home-directory "/home/guix")
                 (supplementary-groups '("wheel" "netdev" "audio" "video" "plugdev")))
               %base-user-accounts))
  
  ;; Channels
  (channels my-channels)

  ;; Firmware
  (firmware (cons* iwlwifi-firmware
                 %base-firmware))

  ;; Packages
  (packages my-system-packages)

  ;; System services
  (services (modify-services %desktop-services
  
   ;; 1. CUPS print
   (cups-service-type config => (cons* (service cups-service-type) config))
    
   ;; 2. Xorg layout
   (xorg-service-type config => (cons* (service xorg-service-type
                                                  (xorg-configuration
                                                   (keyboard-layout keyboard-layout)
                                                   (modules (cons nvda %default-xorg-modules)) ; add nvda module
                                                   (drivers '("nvidia")))) ; use nvidia driver
                                         config))
    
   ;; 3. Substitute
   (guix-service-type config =>
      (service guix-service-type
               (guix-configuration
                (inherit config)
                (substitute-urls '("https://mirror.sjtu.edu.cn/guix/"
                                   "https://ci.guix.gnu.org")))))

   ;; NVIDIA service
   (nvidia-service-type config => (cons* (service nvidia-service-type) config))
  
  ))

  ;; Grub
  (bootloader (bootloader-configuration
               (bootloader grub-bootloader)
               (targets (list "/dev/vda"))
               (keyboard-layout keyboard-layout)))

  (swap-devices (list (swap-space
                       (target (uuid "1a84d528-add4-409e-be6e-40cc01550185")))))

  (file-systems (cons* (file-system
                        (mount-point "/")
                        (device (uuid "ac816367-6831-49e6-932f-80dce599c1ae"))
                        (type "ext4"))
                       %base-file-systems))
)
