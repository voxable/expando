module Expando
  # Represents an Expando entity source file.
  class SourceFiles::EntityFile < SourceFiles::Base
    alias_method :entity_name, :object_name
  end
end
