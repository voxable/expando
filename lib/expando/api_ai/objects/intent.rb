module Expando::ApiAi::Objects
  # Initialized with a hash representing an existing API.ai intent, and the path
  # to an Expando file for that intent, generates the JSON for a new version of
  # the intent.
  #
  # @see https://docs.api.ai/docs/intents#intent-object
  class Intent < Base
    # The list of attributes that can be removed from the intent JSON before updating.
    ATTRIBUTES_TO_REMOVE = %w{auto templates state priority webhookUsed lastUpdate fallbackIntent cortanaCommand}

    # Properly perform all Expando transformations (expansion, annotation) to the
    # source for the intent, generate a new version of the intent's JSON, and update
    # it on API.ai.
    #
    # @return [void]
    def update!
      # Fetch the latest version of the intent from API.ai.
      intent_json = current_version

      # Replace the original utterances with the Expando-processed utterances.
      intent_json[:userSays] = processed_utterances

      # Replace the responses, if a response file exists for this intent.
      intent_json[:responses][0][:speech] = responses if responses

      # Clean up portions of the JSON response that we don't need in the request
      ATTRIBUTES_TO_REMOVE.each { |key| intent_json.delete(key.to_sym) }

      response = @api_client.update_intent_request(intent_json)

      handle_response(response, :intent)
    end

    private

      # Generate new user utterances based on the Expando source for this intent.
      #
      # @return [Array<Hash>] The new `userSays` attribute.
      def processed_utterances
        utterances = Expando::Expander.expand! @source_file.lines

        utterances.collect do |utterance|
          {
            data: [
              text: utterance
            ],
            # TODO: Make this an option
            isTemplate: false
          }
        end
      end

      # Generate new responses for this intent based on the Expando responses source.
      #
      # @return [Array<String>] The new responses.
      def responses
        return false unless @responses_file

        Expando::Expander.expand! @responses_file.lines
      end

      # Fetch the existing intent with this name on Api.ai.
      #
      # @return [Hash] The current version of the intent object on API.ai.
      def current_version
        @@intents ||= @api_client.get_intents_request

        matching_intent = @@intents.select { |intent| intent[:name] == @source_file.intent_name }

        # TODO: needs an exception class
        raise "There is no intent named #{@source_file.intent_name}" if matching_intent.empty?

        intent_id = matching_intent.first[:id]

        Expando::Logger.log "Fetching latest version of #{@source_file.intent_name} intent"
        @api_client.get_intent_request(intent_id)
      end
  end
end
