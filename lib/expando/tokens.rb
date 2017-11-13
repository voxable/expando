# The regular expressions used to match Expando tokens.
module Expando
  module Tokens
    # All text enclosed within parentheses.
    EXPANSION_MATCHER  = /(?<!\\)\((.*?)\)/
    # Any line beginning with a '#' as its first non-whitespace character.
    COMMENT_MATCHER    = /^\s*#/
    # Any entity references (e.g. @location:locationName or @sys.any:name)
    ENTITY_REF_MATCHER = /@((sys\.)?(\w|-)*):(\w*)/
    # All characters until the first entity reference.
    UNTIL_ENTITY_REF_MATCHER = /^(.*?)(?=(@((sys\.)?(\w|-)*):(\w*)))/
  end
end
