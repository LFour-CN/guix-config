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
                 (list "https://mirror.nju.edu.cn/guix/"
                       "https://ci.guix.gnu.org")
                 %default-substitute-urls))
               (authorized-keys
                (append %default-authorized-guix-keys))))
   
   (font-service-type
    config => (font-configuration
               (inherit config)
               (font-specifications
                (list "JetBrains Mono:size=12"
                      "WenQuanYi Micro Hei")))))
)
