require 'json'

module Expando
  module ApiAi
    module Importers
      # Imports intents from existing Dialogflow agents into Expando source files.
      class IntentImporter < Expando::ApiAi::CommandBase
        # Import the named intent from Dialogflow.
        #
        # @return [Boolean]
        #   `true` if request successful.
        # @return [ApiAiRuby::RequestError]
        #   If request is in error.
        def import!
          # Create source file objects for each intent that needs to be imported.
          intent_files = generate_intent_files(object_names)

          # Import each intent.
          object_names.each { |intent| import_intent(intent) }
        end

        private

        # Generate `Expando::SourceFiles::IntentFile` objects (and their
        # matching source files) for each intent that needs to be imported.
        #
        # @private
        #
        # @param [Array<String>] intent_names
        #   The names of the intent files to update.
        #
        # @return [Array<Expando::SourceFiles::IntentFile>]
        #   The generated file objects.
        def generate_intent_files(intent_names = nil)
          # TODO: High- handle error case
          # Fetch the list of intents.
          intents = client.get_intents_request

          # For every intent name...
          intent_names.collect do |intent_name|
            # Fetch the intent with a matching name.
            intent = intents.select { |i| i[:name] == intent_name }.first

            # Raise an error if an intent with this name can't be found.
            raise ArgumentError, "No intent with name #{intent_name} found" unless intent

            # ...generate a new source file path for the intent.
            intent_file_path = File.join(intents_path, "#{intent_name}.txt")

            # Create the intent file on the filesystem.
            FileUtils.touch(intent_file_path)

            # Create the intent file object.
            Expando::SourceFiles::IntentFile.new(intent_file_path)
          end
        end

        # Import an intent to a file in the Expando repo.
        #
        # @private
        #
        # @param [String] intent
        #   The name of the intent to import.
        #
        # @return [void]
        def import_intent(intent)

        end
      end
    end
  end
end



