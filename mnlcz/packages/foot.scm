(define-module (mnlcz packages foot)
  #:use-module (gnu packages terminals)
  #:use-module (guix packages)
  #:use-module (guix gexp))

(define-public foot-plan9
  (package
    (inherit foot)
    (source
     (origin
       (inherit (package-source foot))
       (patches (list (local-file "../../patches/foot-plan9-scrollbar.patch")))))))

