module Expando
  # Represents an Expando intent source file.
  class SourceFiles::IntentFile < SourceFiles::Base
    alias_method :intent_name, :object_name

    # !@attribute id
    #   @return [String] The Dialogflow ID of this intent.
    option :id, Expando::Types::Strict::String, optional: true
  end
end
