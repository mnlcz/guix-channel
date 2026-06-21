(define-module (mnlcz packages hevel)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages freedesktop)
  #:use-module (mnlcz packages neuswc))

(define-public hevel
  (package
    (name "hevel")
    (version "0.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://git.sr.ht/~dlm/hevel/archive/7ef61a5.tar.gz")
       (sha256
        (base32 "0z01s825vhkylmfqhr3whj9pds6w9vys7yb3s4ja208yx6x3l0d2"))))
    (build-system gnu-build-system)
    (arguments
     '(#:tests? #f
       #:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" %output))
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (add-before 'build 'copy-config
                    (lambda _
                      (copy-file "config.def.h" "config.h"))))))
    (native-inputs (list pkg-config))
    (inputs (list wayland neuswc))
    (synopsis "Wayland compositor based on swc")
    (description "hevel is a small Wayland compositor built on top of neuswc.")
    (home-page "https://git.sr.ht/~dlm/hevel")
    (license license:expat)))
