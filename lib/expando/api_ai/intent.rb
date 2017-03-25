module Expando
  module ApiAi
    # Initialized with a hash representing an existing API.ai intent (if one exists),
    # and the path to an Expando file for that intent, generates a new version
    # of the intent.
    #
    # @see https://docs.api.ai/docs/intents#intent-object
    class Intent
      extend ::Dry::Initializer

      param  :intent_path,     Expando::Types::Strict::String
      option :existing_intent, Expando::Types::Hash, optional: true
    end
  end
end
