module Expando::ApiAi
  # Initialized with a hash representing an existing API.ai intent, and the path
  # to an Expando file for that intent, generates the JSON for a new version of
  # the intent.
  #
  # @see https://docs.api.ai/docs/intents#intent-object
  class Intent
    extend ::Dry::Initializer



    # Properly perform all Expando transformations (expansion, annotation) to the
    # source for the intent and generate a new version of the intent's JSON.
    def to_json

    end

    private

    # Fetch the existing intent with this name on Api.ai.
    #
    # @return [Hash] The current version of the intent object on API.ai.
    def current_version
      unless @@intents
        log_message 'Fetching intents'
        @@intents = @client.get_intents_request
      end

      matching_intent = intents.select { |intent| intent[:name] == name }

      # TODO: needs an exception class
      raise "There is no intent named #{name}" if matching_intent.empty?

      intent_id = matching_intent.first[:id]

      log_message "Fetching latest version of #{name} intent"
      @client.get_intent_request(intent_id)
    end

    # @return [String] The name of this intent.
    def name
      @name ||= File.split(@source_path).last.gsub('.txt', '')
    end
  end
end
