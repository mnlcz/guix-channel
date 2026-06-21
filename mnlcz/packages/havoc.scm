(define-module (mnlcz packages havoc)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages xdisorg))

(define-public havoc
  (package
    (name "havoc")
    (version "0.7.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://github.com/ii8/havoc/archive/fe9e4c9.tar.gz")
       (sha256
        (base32 "17pkr3zpr0fv1kzp7kqkx9jqyn18z4yibrx75wwv4ix895zpyzcc"))))
    (build-system gnu-build-system)
    (arguments
     '(#:tests? #f
       #:make-flags (list (string-append "PREFIX=" %output))
       #:phases (modify-phases %standard-phases
                  (delete 'configure))))
    (native-inputs (list pkg-config wayland))
    (inputs (list wayland wayland-protocols libxkbcommon))
    (synopsis "Minimal Wayland terminal")
    (description "havoc is a minimal terminal emulator for Wayland.")
    (home-page "https://github.com/ii8/havoc")
    (license expat)))
