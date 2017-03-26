module Expando
  # Represents an Expando entity source file.
  class SourceFiles::EntityFile < SourceFiles::Base
    alias_method :entity_name, :object_name

    # TODO: High - document and test
    def random_canonical_value
      lines.collect { |line| line.split(',').first }.sample
    end
  end
end
