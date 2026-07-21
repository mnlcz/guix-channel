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
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (share (string-append out "/share/wayland-sessions"))
                     (bin (string-append out "/bin/wio-session")))
                (mkdir-p share)
                (call-with-output-file bin
                  (lambda (port)
                    (display (string-append "#!/bin/sh\n"
                              "export __EGL_VENDOR_LIBRARY_FILENAMES="
                              "/gnu/store/jjvaib8vmzwrw39g9p8jzxmhl7k2hafw-nvda-580.15"
                              "/share/glvnd/egl_vendor.d/10_nvidia.x86_64.json"
                              "export __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS="
                              "/gnu/store/mg4kkzdvclsqpi43x0aa2nnrksqz791v-egl-wayland2-1.0.1"
                              "/share/egl/egl_external_platform.d:"
                              "/gnu/store/h5qvl0sssi8p2knrfyvz5r0xhas2-egl-gbm-1.1.3"
                              "/share/egl/egl_external_platform.d\n"
                              "export VK_ICD_FILENAMES="
                              "/gnu/store/jjvaib8vmzwrw39g9p8jzxmhl7k2hafw-nvda-580.15"
                              "/share/vulkan/icd.d/nvidia_icd.x86_64.json"
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
                  cage-0.20))
    (synopsis "Wayland compositor inspired by Plan 9's rio")
    (description
     "Wio is a Wayland compositor with a similar look and feel to Plan 9's rio,
built on wlroots.")
    (home-page "https://gitlab.com/Rubo/wio")
    (license license:bsd-3)))

