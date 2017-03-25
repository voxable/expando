module Expando
  module SourceFiles
    # The base class for all Expando source files
    class Base
      extend ::Dry::Initializer

      # The path to the Expando source file.
      param :source_path, Expando::Types::Strict::String
    end
  end
end
