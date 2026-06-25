(define-module (mnlcz packages wio)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system meson)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages wm)
  #:use-module (nongnu packages nvidia))

(define-public wio
  (package
    (name "wio")
    (version "0.0.1")
    (source
     (origin
       (method url-fetch)
       (uri "https://gitlab.com/Rubo/wio/-/archive/master/wio-master.tar.gz")
       (sha256
        (base32 "1y7dzhyna557a5gg8850mdfp34p0d6czn712h0gqs5li82p17zmi"))))
    (build-system meson-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'fix-wlroots-dep
            (lambda _
              (substitute* "meson.build"
                (("wlroots-0\\.19")
                 "wlroots-0.20"))))
          (add-after 'install 'install-desktop-file
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((share (string-append (assoc-ref outputs "out")
                                          "/share/wayland-sessions")))
                (mkdir-p share)
                (call-with-output-file (string-append share "/wio.desktop")
                  (lambda (port)
                    (display "[Desktop Entry]
Name=wio
Comment=Rio-inspired Wayland compositor
Exec=wio -t havoc
Type=Application
" port)))))))))
    (native-inputs (list pkg-config))
    (inputs (list cairo
                  libdrm
                  wayland
                  wayland-protocols
                  (replace-mesa wlroots
                                #:driver nvda-580)
                  libxkbcommon
                  cage))
    (synopsis "Wayland compositor inspired by Plan 9's rio")
    (description
     "Wio is a Wayland compositor with a similar look and feel to Plan 9's rio,
built on wlroots.")
    (home-page "https://gitlab.com/Rubo/wio")
    (license license:bsd-3)))
