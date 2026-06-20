(define-module (mnlcz packages neuwld)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system meson)
  #:use-module (guix licenses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages xdisorg))

(define-public neuwld
  (package
    (name "neuwld")
    (version "0.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://git.sr.ht/~shrub900/neuwld/archive/bb5d247.tar.gz")
       (sha256
        (base32 "0f0zcv0av6jq8ih6gfvfgsyyp59sdkrsr0najr55imalji9m54gl"))))
    (build-system meson-build-system)
    (native-inputs (list pkg-config))
    (inputs (list fontconfig pixman freetype wayland libdrm))
    (synopsis "Primitive drawing library targeted at Wayland")
    (description
     "neuwld is a primitive drawing library targeted at Wayland compositors.")
    (home-page "https://git.sr.ht/~shrub900/neuwld")
    (license expat)))
