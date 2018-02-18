module Expando
  module ApiAi
    # Initializers and constants common to classes that carry out Dialogflow
    # command.
    class CommandBase

      # The default location of intent source files
      DEFAULT_INTENTS_PATH = File.join(Dir.pwd, 'intents')

      # The default location of entity source files
      DEFAULT_ENTITIES_PATH = File.join(Dir.pwd, 'entities')

      # The default location of intent response source files
      DEFAULT_RESPONSES_PATH = File.join(Dir.pwd, 'responses')

      extend ::Dry::Initializer

      # !@attribute object_names
      #   @return [Array<String>] The names of the objects to be updated.
      param :object_names, Expando::Types::Strict::Array, optional: true

      # !@attribute intents_path
      #   @return [String] The path to the directory containing the intent source
      #     files. (default: './intents')
      option :intents_path, Expando::Types::Strict::String,
             default: proc { DEFAULT_INTENTS_PATH }

      # !@attribute entities_path
      #   @return [String] The path to the directory containing the entity source
      #     files. (default: './entities')
      option :entities_path, Expando::Types::Strict::String,
             default: proc { DEFAULT_ENTITIES_PATH }

      # !@attribute responses_path
      #   @return [String] The path to the directory containing the intent response
      #     source files. (default: './responses')
      option :responses_path, Expando::Types::Strict::String,
             default: proc { DEFAULT_RESPONSES_PATH }

      # !@attribute developer_access_token
      #   @return [String] The API.ai developer access token.
      option :developer_access_token, Expando::Types::Strict::String

      # !@attribute client_access_token
      #   @return [String] The API.ai client access token.
      option :client_access_token, Expando::Types::Strict::String

      protected

      # @private
      # @return [VoxableApiAiRuby::Client] An API.ai API client for this project's agent.
      def client
        @client ||= VoxableApiAiRuby::Client.new({
          client_access_token:    client_access_token,
          developer_access_token: developer_access_token
        })
      end

      # Generate `Expando::ApiAi::Intent` objects for each passed intent source
      # file.
      #
      # @private
      #
      # @param [Array<Expando::SourceFiles::IntentFile>] intent_files
      #   The intent source files.
      # @param [Array<Expando::SourceFiles::ResponsesFile>] responses_files
      #   The intent responses source files.
      # @param [Array<Expando::SourceFiles::EntitiesFile>] entity_files
      #   The entity source files.
      #
      # @return [Array<Expando::ApiAi::Intent>]
      #   The generated intent objects.
      def generate_intents(intent_files, responses_files = [], entity_files = [])
        intent_files.collect do |intent_file|
          # Find a matching responses file for this intent file, if one exists.
          responses_file = responses_files.select { |file|
            file.intent_name == intent_file.intent_name
          }.first

          Expando::ApiAi::Objects::Intent.new(
            source_file:    intent_file,
            responses_file: responses_file,
            entity_files:   entity_files,
            api_client:     client
          )
        end
      end

      # Generate `Expando::ApiAi::Entity` objects for each passed entity
      # source file.
      #
      # @param [Array<Expando::SourceFiles::EntityFile>] entity_files
      #   The entity source files.
      #
      # @return [Array<Expando::ApiAi::Entity>]
      #   The generated entity objects.
      def generate_entities(entity_files)
        entity_files.collect do |entity_file|
          Expando::ApiAi::Objects::Entity.new(
            source_file:    entity_file,
            api_client:     client,
            id:             entity_file.id
          )
        end
      end
    end
  end
end
