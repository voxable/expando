module Expando
  module SourceFiles
    # The base class for all Expando source files
    class Base
      extend ::Dry::Initializer

      # The path to the Expando source file.
      param :source_path, Expando::Types::Strict::String


      # Generate an array of strings for each line in the file.
      #
      # @return [Array<String>] An array of all of the lines in the file.
      def lines
        File.read(source_path).lines.collect{ |line| line.chomp }
      end
    end
  end
end
