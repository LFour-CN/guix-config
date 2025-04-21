(define-module (dotfiles system system-services)
  #:use-module (gnu services)
  #:export (system-services))

(define system-services
  (modify-services %desktop-services
   (guix-service-type
    config => (guix-configuration
               (inherit config)
               (substitute-urls
                (append
                 (list  
                       "https://mirrors.sjtug.sjtu.edu.cn/guix/"
                       "https://mirror.nju.edu.cn/guix/"
                       "https://mirror.sjtu.edu.cn/guix/"
                       "https://ci.guix.gnu.org")
                 %default-substitute-urls))
               (authorized-keys
                (append %default-authorized-guix-keys))))
  )
)
