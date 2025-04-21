(use-modules 
  (gnu)
  (dotfiles system hardware)
  (dotfiles system locale)
  (dotfiles system users)
  (dotfiles system storage)
  (dotfiles system system-services)
  (dotfiles system system-packages))

(operating-system
  ;; Hardware config
  (hardware-config (hardware-configuration))
  ;; Locale config
  (locale-config (locale-configuration))
  ;; Users config
  (users-config (users-configuration))
  ;; Packages config
  (packages (system-packages))
  ;; System services config
  (services (system-services))
  ;; Storaage config
  (storage-config (storage-configuration))  
  ;; Hostname
  (host-name "linux-libre")
)
