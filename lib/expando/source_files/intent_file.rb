module Expando
  # Represents an Expando intent source file.
  class SourceFiles::IntentFile < SourceFiles::Base
    alias_method :intent_name, :object_name
  end
end
