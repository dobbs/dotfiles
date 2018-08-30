(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Hack")

  ;; WARNING!  Depending on the default font,
  ;; if the size is not supported very well, the frame will be clipped
  ;; so that the beginning of the buffer may not be visible correctly.
  ;; (set-face-attribute 'default nil :height 165)
  )
(setq prelude-theme 'solarized-light)
