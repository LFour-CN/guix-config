(define-module (dotfiles home users-packages)
  #:export (users-packages))

(define users-packages
  (specifications->packages
   '( 
       "python" 
       "jupyter" 
    )
  )
)
