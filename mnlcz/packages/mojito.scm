(define-module (mnlcz packages mojito)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages xdisorg)
  #:use-module (mnlcz packages neuwld)
  #:use-module (mnlcz packages neuswc))

(define-public mojito
  (package
    (name "mojito")
    (version "4c6b988")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://git.sr.ht/~dlm/mojito/archive/4c6b988e1927cff3bd6ffe22c552c31cd356dfca.tar.gz")
       (sha256
        (base32 "140l4fppcc0d9bbqlgrhaskphsmshyicab4sbjndx8x2rn10gpjs"))))
    (build-system gnu-build-system)
    (arguments
     '(#:tests? #f
       #:make-flags (list "CC=gcc"
                          (string-append "DESTDIR=" %output))
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (add-before 'build 'fix-includes
                    (lambda* (#:key inputs #:allow-other-keys)
                      (setenv "C_INCLUDE_PATH"
                              (string-append (assoc-ref inputs "pixman")
                                             "/include/pixman-1:"
                                             (getcwd) "/protocol:"
                                             (or (getenv "C_INCLUDE_PATH") ""))))))))
    (native-inputs (list pkg-config wayland gcc-toolchain))
    (inputs (list wayland
                  wayland-protocols
                  libdrm
                  pixman
                  libxkbcommon
                  fontconfig
                  neuwld
                  neuswc))
    (synopsis "Featherweight lemonbar-compatible bar for Wayland")
    (description
     "mojito is a minimal, lemonbar-compatible status bar for Wayland compositors using neuswc.")
    (home-page "https://git.sr.ht/~dlm/mojito")
    (license bsd-0)))
