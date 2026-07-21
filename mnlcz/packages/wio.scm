(define-module (mnlcz packages wio)
  #:use-module (mnlcz packages cage)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system meson)
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

(define-public wio
  (package
    (name "wio")
    (version "0.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mnlcz/wio")
             (commit "21ce3da8d5d6086baa4a711a32f226a99b132f7c")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0n18jwz77ga5w21bmvhs4wmglz4y1xm68adch242wvm3cd17dpad"))))
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
                                (search-input-file inputs "bin/cage") " -d\";")))))
          (add-after 'install 'install-extras
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (share (string-append out "/share/wayland-sessions"))
                     (bin (string-append out "/bin/wio-session"))
                     (nvda-dir (assoc-ref inputs "nvda")))
                (mkdir-p share)
                (call-with-output-file bin
                  (lambda (port)
                    (display (string-append "#!/bin/sh\n"
                              "__EGL_VENDOR_LIBRARY_FILENAMES=\n"
                              "for f in "
                              nvda-dir
                              "/share/glvnd/egl_vendor.d/*.json; do\n"
                              "  __EGL_VENDOR_LIBRARY_FILENAMES=\"${__EGL_VENDOR_LIBRARY_FILENAMES:+$__EGL_VENDOR_LIBRARY_FILENAMES:}$f\"
"
                              "done\n"
                              "export __EGL_VENDOR_LIBRARY_FILENAMES\n"
                              "export __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS="
                              nvda-dir
                              "/share/egl/egl_external_platform.d\n"
                              "VK_ICD_FILENAMES=\n"
                              "for f in "
                              nvda-dir
                              "/share/vulkan/icd.d/*.json; do\n"
                              "  VK_ICD_FILENAMES=\"${VK_ICD_FILENAMES:+$VK_ICD_FILENAMES:}$f\"
"
                              "done\n"
                              "export VK_ICD_FILENAMES\n"
                              "export WLR_NO_HARDWARE_CURSORS=1\n"
                              "exec wio -t havoc\n") port)))
                (chmod bin #o755)
                (call-with-output-file (string-append share "/wio.desktop")
                  (lambda (port)
                    (display "[Desktop Entry]
Name=wio
Comment=Rio-inspired Wayland compositor
Exec=wio-session
Type=Application
" port)))))))))
    (native-inputs (list pkg-config))
    (inputs (list cairo
                  libdrm
                  wayland
                  wayland-protocols
                  (replace-mesa wlroots)
                  libxkbcommon
                  cage-0.20
                  guile-3.0
                  nvda-580))
    (synopsis "Wayland compositor inspired by Plan 9's rio")
    (description
     "Wio is a Wayland compositor with a similar look and feel to Plan 9's rio,
built on wlroots.")
    (home-page "https://github.com/mnlcz/wio")
    (license license:bsd-3)))

