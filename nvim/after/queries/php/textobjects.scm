; extends

(heredoc) @heredoc.outer

(heredoc
  (heredoc_body) @heredoc.inner
  (#trim! @heredoc.inner 1 1 1 1))

(nowdoc) @heredoc.outer

(nowdoc
  (nowdoc_body) @heredoc.inner)
