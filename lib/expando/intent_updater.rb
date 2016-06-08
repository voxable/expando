require 'json'

module Expando
  # Responsible for updating intent objects on Api.ai based on the contents of
  # files in `/intents`.
  class IntentUpdater < Updater
    # !@attribute name
    #   @return [String] the name of the intent to be updated
    attr_accessor :name

    # !@attribute intents_path
    #   @return [String] the path to the directory containing the intent source files
    attr_accessor :intents_path

    # Initialize a new `IntentUpdater`.
    #
    # @see Updater#initialize
    def initialize( * )
      super
    end

    # Update the named entity on Api.ai.
    #
    # @return [Hash] if request successful. This is the response body.
    # @return [ApiAiRuby::RequestError] if request is in error.
    def update!
      response = @client.update_intent_request( intent_json )

      handle_response( response, :intent )
    end

    private

    # Construct a proper JSON object for updating the intent, based on its current
    #   state plus the expanded templates
    #
    # @return [Hash] The constructed JSON of for the intent.
    def intent_json
      @id = intent_id

      log_message "Fetching latest version of #{ @name } intent"
      json = @client.get_intent_request( @id )

      json[ :userSays ] = expanded_utterances

      # TODO: Make this a separate, tested method
      responses_path = File.join( File.expand_path( @intents_path ), '..', 'responses', @name.to_s + '.txt' )

      if File.exist?(responses_path)
        responses = File.readlines
        responses = responses.collect { |response| response.chomp }

        responsesJson = json[ :responses ]
        responsesJson[ 0 ][ :speech ] = responses
        json[:responses] = responsesJson
      end

      # Clean up portions of the JSON response that we don't need in the request
      %w{templates state priority webhookUsed}.each { |key| json.delete( key.to_sym ) }

      json
    end

    # Fetch the ID of the intent with this name on Api.ai.
    #
    # @return [String] The ID of the intent with this `@name` on Api.ai.
    def intent_id
      log_message "Fetching id of #{ @name } intent"
      intents = @client.get_intents_request

      matching_intent = intents.select { |intent| intent[ :name ] == @name.to_s }

      if matching_intent.empty?
        # TODO: Consult Exceptional Ruby for a better way to do this
        raise "There is no intent named #{@name}"
      else
        return matching_intent.first[ :id ]
      end
    end

    # @return [Array<String>] The expanded list of intent utterances.
    def expanded_utterances
      intent_utterance_file_path = File.join( File.expand_path( @intents_path ), @name.to_s + '.txt')
      # TODO: Test
      utterances = Expander.expand! file_lines( intent_utterance_file_path )

      utterances.collect do |utterance|
        {
          data: [
              text: utterance
          ],
          # TODO: Make this an aption
          isTemplate: false
        }
      end
    end
  end
end

