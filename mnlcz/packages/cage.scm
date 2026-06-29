(define-module (mnlcz packages cage)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system meson)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages wm)
  #:use-module (nongnu packages nvidia))

(define-public cage-0.20
  (package
    (name "cage")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri "https://github.com/cage-kiosk/cage/archive/refs/tags/v0.2.1.tar.gz")
       (sha256
        (base32 "1a9l28cgfckw4vf6zzvs37vw9gfyrcw97y5rsy4afr2i2y1hraxc"))))
    (build-system meson-build-system)
    (arguments
     (list #:tests? #f))
    (native-inputs (list pkg-config))
    (inputs (list wayland (replace-mesa wlroots) libxkbcommon))
    (synopsis "Wayland kiosk compositor")
    (description "Cage is a kiosk compositor for Wayland.")
    (home-page "https://github.com/cage-kiosk/cage")
    (license license:expat)))
