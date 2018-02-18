module Expando::ApiAi
  module Updaters
    class Base
      extend ::Dry::Initializer

      # The default location of intent source files
      DEFAULT_INTENTS_PATH = File.join( Dir.pwd, 'intents')

      # The default location of entity source files
      DEFAULT_ENTITIES_PATH = File.join( Dir.pwd, 'entities' )

      # The default location of intent response source files
      DEFAULT_RESPONSES_PATH = File.join( Dir.pwd, 'responses' )

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

      def update
        raise NotImplementedError, '#update must be overridden in subclass'
      end

      private

        # @return [VoxableApiAiRuby::Client] An API.ai API client for this project's agent.
        def client
          @client ||= VoxableApiAiRuby::Client.new({
            client_access_token:    client_access_token,
            developer_access_token: developer_access_token
          })
        end

        # Generate `Expando::SourceFiles::EntityFile` objects for each entity matching
        #   the passed `entity_names`, or for all entities in the directory if none passed.
        #
        # @param [Array<String>] entity_names The names of the entity files to update.
        #
        # @return [Array<Expando::SourceFiles::EntityFile>] The generated file objects.
        def generate_entity_files(entity_names = nil)
          # TODO: Throw an error when a non-existing entity is requested.

          # Get a list of all entity file names.
          entity_file_names = Dir.entries(entities_path)[2..-1]

          # If the entities to update have been specified...
          if entity_names && entity_names.any?
            # ...reduce the list of entity source file names only to those that
            # match the requested entities.
            entity_file_names.reject! do |file_name|
              entity_file_base_name = File.basename(file_name, '.*')
              !entity_names.include?(entity_file_base_name)
            end
          end

          # Generate an array of full file paths to the requested entity source files.
          entity_file_paths = entity_file_names.collect { |name| File.join(entities_path, name) }

          # Generate a list of Expando::SourceFiles::EntityFile objects for each entity.
          entity_file_paths.collect { |path| Expando::SourceFiles::EntityFile.new(path) }
        end
    end
  end
end
