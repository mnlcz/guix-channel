(define-module (mnlcz packages wio)
  #:use-module (mnlcz packages cage)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system meson)
  #:use-module (guix search-paths)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages window-management)
  #:use-module (nongnu packages nvidia))

(define (guile-effective-version pkg)
  (let ((parts (string-split (package-version pkg) #\.)))
    (string-append (car parts) "." (cadr parts))))


(define-public wio
  (package
    (name "wio")
    (version "0.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mnlcz/wio")
             (commit "de3606f3826fcfe072e4401f3b532cfd23cd0901")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0mnbf3j6r0m20hr6ng5xgridpqmhvcqpl4xq0nxbdss6f1ndwixh"))))
    (build-system meson-build-system)
    (arguments
     (list
      #:build-type "debug"
      #:tests? #f
      #:strip-binaries? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'fix-wlroots-dep
            (lambda _
              (substitute* "meson.build"
                (("wlroots-0\\.19")
                 "wlroots-0.20"))))
          (add-after 'fix-wlroots-dep 'fix-cage-path
            (lambda* (#:key inputs #:allow-other-keys)
              (substitute* "main.c"
                (("server\\.cage = \"cage -d\";")
                 (string-append "server.cage = \""
                                (search-input-file inputs "bin/cage") " -d\";"))))))))
    (native-inputs (list pkg-config))
    (inputs (list cairo
                  libdrm
                  wayland
                  wayland-protocols
                  (replace-mesa wlroots)
                  libxkbcommon
                  cage-0.20
                  guile-3.0))
    (native-search-paths
     (list (search-path-specification
            (variable "GUILE_LOAD_PATH")
            (files (list (string-append "share/guile/site/"
                                        (guile-effective-version guile-3.0)))))))
    (synopsis "Wayland compositor inspired by Plan 9's rio")
    (description
     "Wio is a Wayland compositor with a similar look and feel to Plan 9's rio,
built on wlroots.")
    (home-page "https://github.com/mnlcz/wio")
    (license license:bsd-3)))

