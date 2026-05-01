; extends

(match_expression) @match.outer

(match_expression
  body: (match_block
    (_) @match.inner))

(match_arm) @match_arm.outer

(match_arm
  value: (_) @match_arm.inner)

(match_arm
  pattern: (_) @match_arm.pattern)
