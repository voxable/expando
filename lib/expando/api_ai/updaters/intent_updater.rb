require 'json'

module Expando::ApiAi::Updaters
  # Updates intent objects on Api.ai based on the contents of Expando source files.
  class IntentUpdater < Base
    # Update the named entity on Api.ai.
    #
    # @return [Hash] if request successful. This is the response body.
    # @return [ApiAiRuby::RequestError] if request is in error.
    def update!
      # Create source file objects for each intent that needs to be updated.
      intent_files = generate_intent_files(object_names)

      # Create intent objects for each intent source file.
      intents = generate_intents(intent_files)

      puts intents.inspect
    end

    private

      # Generate `Expando::SourceFiles::IntentFile` objects for each intent matching
      #   the passed `object_names`, or for all intents in the directory if none passed.
      #
      # @param [Array<String>] intent_names The names of the intent files to update.
      #
      # @return [Array<Expando::SourceFiles::IntentFile>] The generated file objects.
      def generate_intent_files(intent_names = nil)
        # TODO: Throw an error when a non-existing intent is requested.

        # Get a list of all intent file names.
        intent_file_names = Dir.entries(intents_path)[2..-1]

        # If the intents to update have been specified...
        if intent_names.any?
          # ...reduce the list of file names only to those that match the requested intents.
          intent_file_names.reject! do |file_name|
            intent_file_base_name = File.basename(file_name, '.*')

            !intent_names.include?(intent_file_base_name)
          end
        end

        # Generate an array of full file paths to the requested intent source files.
        intent_file_paths = intent_file_names.collect { |name| File.join(intents_path, name) }

        # Generate a list of Expando::SourceFiles::IntentFile objects for each intent.
        intent_file_paths.collect { |path| Expando::SourceFiles::IntentFile.new(path) }
      end

      # @return [ApiAiRuby::Client] An API.ai client for this project's agent.
      def client
        @client ||= ApiAiRuby::Client.new(
           developer_access_token: developer_access_token,
           client_access_token:    client_access_token
        )
      end

      # Generate `Expando::ApiAi::Intent` objects for each passed intent source file.
      #
      # @param [Array<Expando::SourceFiles::IntentFile>] intent_files The intent source files.
      #
      # @return [Array<Expando::ApiAi::Intent>] The generated intent objects.
      def generate_intents(intent_files)
        intent_files.collect do |file|
          Expando::ApiAi::Objects::Intent.new(source_file: file, api_client: client)
        end
      end

      # Construct a proper JSON object for updating the intent, based on its current
      #   state plus the expanded templates
      #
      # @return [Hash] The constructed JSON of for the intent.
      def intent_json
        @id = intent_id

        log_message "Fetching latest version of #{ @name } intent"
        json = @client.get_intent_request( @id )

        json[ :userSays ] = expanded_utterances

        responses_path = responses_file_path(@name)

        if File.exist?(responses_path)
          responses = File.readlines responses_path
          responses = responses.collect { |response| response.chomp }

          responsesJson = json[ :responses ]
          responsesJson[ 0 ][ :speech ] = responses
          json[:responses] = responsesJson
        end

        # Clean up portions of the JSON response that we don't need in the request
        %w{auto templates state priority webhookUsed lastUpdate fallbackIntent cortanaCommand}.each { |key| json.delete( key.to_sym ) }

        json
      end

      # Generate the path for the intent source file.
      #
      # @param name [String] The name of the intent.
      #
      # @return [String] The path to the intent source file.
      def intents_file_path(name)
        file_path_for("#{name}.txt")
      end

      # Generate the path for the intent response file.
      #
      # @param name [String] The name of the intent.
      #
      # @return [String] The path to the intent response file.
      def responses_file_path(name)
        file_path_for('..', 'responses', "#{name}.txt")
      end

      # Generate a source file path, based on the root intents source path.
      #
      # @param segments [Array<String>] The segments of the file path.
      #
      # @return [String] The full intent source file path.
      def file_path_for(*segments)
        File.send(:join, File.expand_path(@intents_path), segments)
      end



      # @return [Array<String>] The expanded list of intent utterances.
      def expanded_utterances
        intent_utterance_file_path = intents_file_path(@name)
        # TODO: Test
        utterances = Expando::Expander.expand! file_lines( intent_utterance_file_path )

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

