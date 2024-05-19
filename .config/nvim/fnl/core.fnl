(local plugins (require :plugins))

(fn setup []
  (require :mappings)
  (require :general)
  (plugins.setup)
  nil)

{: setup}
