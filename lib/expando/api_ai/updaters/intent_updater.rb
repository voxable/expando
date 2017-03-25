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

      # Update each intent.
      intents.each { |intent| intent.update! }
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
        if intent_names && intent_names.any?
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
  end
end

