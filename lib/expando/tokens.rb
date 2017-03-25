# The regular expressions used to match Expando tokens.
module Expando
  module Tokens
    # Find all text enclosed within parentheses.
    EXPANSION_MATCHER = /(?<!\\)\((.*?)\)/
    # Find any line beginning with a '#' as its first non-whitespace character.
    COMMENT_MATCHER   = /^\s*#/
  end
end
