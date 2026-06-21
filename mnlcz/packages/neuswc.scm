(define-module (mnlcz packages neuswc)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system meson)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages xdisorg)
  #:use-module (mnlcz packages neuwld))

(define-public neuswc
  (package
    (name "neuswc")
    (version "0.0")
    (source
      (origin
        (method url-fetch)
        (uri "https://git.sr.ht/~shrub900/neuswc/archive/975ad56.tar.gz")
        (sha256
          (base32
            "1sbpjr0dc4mylcfy2mx7nrlb17xrw8ll96a46qx6zmxvgd0pk7m6"))))
    (build-system meson-build-system)
    (native-inputs
      (list pkg-config))
    (inputs
      (list wayland
            wayland-protocols
            libdrm
            pixman
            libxkbcommon
            libinput
            eudev
            neuwld))
    (synopsis "Wayland compositor library")
    (description "neuswc is a fork of swc introducing new compositor features.")
    (home-page "https://git.sr.ht/~shrub900/neuswc")
    (license license:expat)))
