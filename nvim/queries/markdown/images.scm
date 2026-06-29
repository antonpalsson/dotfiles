; extends

; Render inline ```svg``` code blocks as images (snacks.image -> magick).
; snacks only ships rules for `mermaid` and `math`; this adds `svg`.
(fenced_code_block
  (info_string (language) @lang)
  (#eq? @lang "svg")
  (code_fence_content) @image.content
  (#set! image.ext "svg")
) @image
