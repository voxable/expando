module Expando::ApiAi::Updaters
  # Responsible for updating entity objects on Dialogflow based on the contents of
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
      entities.each(&:update!)
    end
  end
end
