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
        (base32 "1y7dzhyna557a5gg8850mdfp34p0d6czn712h0gqs5li82p17zmi"))
       (patches (list (local-file
                       "/home/mnlcz/Projects/guix-channel/patches/wio-layer-shell-0.20.patch")
		      (local-file
			"/home/mnlcz/Projects/guix-channel/patches/wio-output-fbox-0.20.patch")))))
    (build-system meson-build-system)
    (arguments
     (list
      #:build-type "debug"
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'fix-wlroots-dep
            (lambda _
              (substitute* "meson.build"
                (("wlroots-0\\.19")
                 "wlroots-0.20"))))
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
                              "/share/glvnd/egl_vendor.d/10_nvidia.x86_64.json
"
                              "export __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS="
                              "/gnu/store/mg4kkzdvclsqpi43x0aa2nnrksqz791v-egl-wayland2-1.0.1"
                              "/share/egl/egl_external_platform.d:"
                              "/gnu/store/h5qvl0sssi8p2knrfyvz5r0xhas2-egl-gbm-1.1.3"
                              "/share/egl/egl_external_platform.d\n"
                              "export VK_ICD_FILENAMES="
                              "/gnu/store/jjvaib8vmzwrw39g9p8jzxmhl7k2hafw-nvda-580.15"
                              "/share/vulkan/icd.d/nvidia_icd.x86_64.json
"
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
                  cage))
    (synopsis "Wayland compositor inspired by Plan 9's rio")
    (description
     "Wio is a Wayland compositor with a similar look and feel to Plan 9's rio,
built on wlroots.")
    (home-page "https://gitlab.com/Rubo/wio")
    (license license:bsd-3)))
