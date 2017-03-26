module Expando::ApiAi::Updaters
  # Responsible for updating entity objects on API.ai based on the contents of
  # files in `/entities`.
  class EntityUpdater < Base
    # Update the named entity on API.ai.
    #
    # @return [Hash] if request successful. This is the response body.
    # @return [ApiAiRuby::RequestError] if request is in error.
    def update!
      # Create source file objects for each entity that needs to be updated.
      entity_files = generate_entity_files(object_names)

      # Create entity objects for each entity source file.
      entities = generate_entities(entity_files)

      # Update each entity.
      entities.each { |entity| entity.update! }
    end

    private

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

      # Generate `Expando::ApiAi::Entity` objects for each passed entity source file.
      #
      # @param [Array<Expando::SourceFiles::EntityFile>] entity_files
      #   The entity source files.
      #
      # @return [Array<Expando::ApiAi::Entity>] The generated entity objects.
      def generate_entities(entity_files)
        entity_files.collect do |entity_file|
          Expando::ApiAi::Objects::Entity.new(
            source_file:    entity_file,
            api_client:     client
          )
        end
      end
  end
end
