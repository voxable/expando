# The `Expander` module is responsible for taking an array of intents or utterances,
# and expanding any strings containing the following tokens:
#
#     {I|we} heard you {love|hate} computers
#
# into the following Cartesian product:
#
#     I heard you love computers
#     I heard you hate computers
#     we heard you love computers
#     we heard you hate computers
#
# This greatly reduces the complexity of creating performant speech interfaces.
module Expando
  module Expander
    TOKEN_REGEX = /(?<!\\)\((.*?)\)/

    module_function

    # Generate a new `Expander`.
    #
    # @param [Array<String>] lines The text to scan and expand.
    # @return [Array] The expanded text.
    def expand!( lines )
      expanded_lines = []

      lines.each do |line|
        tokens = line.scan TOKEN_REGEX

        # Don't perform expansion if no tokens are present.
        if tokens.empty?
          expanded_lines << line
          next
        end

        expanded_tokens = []
        tokens.each_with_index do |token, index|
          expanded_tokens[index] = token[0].split( '|' )
        end

        # Produce Cartesian product of all tokenized values.
        token_product = expanded_tokens[ 0 ].product( *expanded_tokens[ 1..-1 ] )

        # Generate new expanded lines.
        token_product.each do |replacement_values|
          expanded_line = line

          replacement_values.each do |value|
            expanded_line = expanded_line.sub( TOKEN_REGEX, value )
          end

          expanded_lines << expanded_line
        end
      end

      expanded_lines
    end
  end
end