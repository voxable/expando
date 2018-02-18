module Expando
  module SourceFiles
    # The base class for all Expando source files
    class Base
      extend ::Dry::Initializer

      # The path to the Expando source file.
      param :source_path, Expando::Types::Strict::String

      # Generate an array of strings for each source line in the file (comments
      # are ignored).
      #
      # @return [Array<String>]
      #   An array of all of the lines in the file.
      def lines
        File
          .read(@source_path)
          .lines
          .map(&:chomp)
          .reject { |line| line.strip.empty? || line.match(Tokens::COMMENT_MATCHER) }
      end

      # Generate the name of the intent based on the name of its associated source file.
      #
      # @return [String]
      #   The name of this intent.
      def object_name
        @name ||= File.split(@source_path).last.gsub('.txt', '')
      end
    end
  end
end
