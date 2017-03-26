# The regular expressions used to match Expando tokens.
module Expando
  module Tokens
    # All text enclosed within parentheses.
    EXPANSION_MATCHER  = /(?<!\\)\((.*?)\)/
    # Any line beginning with a '#' as its first non-whitespace character.
    COMMENT_MATCHER    = /^\s*#/
    # Any entity references (e.g. @location:locationName)
    ENTITY_REF_MATCHER = /@(\w*):(\w*)/
    # All characters until the first entity reference.
    UNTIL_ENTITY_REF_MATCHER = /^(.*?)(?=(@(\w*):(\w*)))/
  end
end
