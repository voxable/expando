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
