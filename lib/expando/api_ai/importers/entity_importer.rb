# frozen_string_literal: true

module Expando
  module ApiAi
    module Importers
      # Imports entities from existing Dialogflow agents into Expando source files.
      class EntityImporter < Expando::ApiAi::CommandBase
        # Import the named entity from Dialogflow.
        #
        # @return [Boolean]
        #   `true` if request successful.
        # @return [ApiAiRuby::RequestError]
        #   If request is in error.
        def import!
          # Create source file objects for each entity that needs to be imported.
          entity_files = generate_entity_files(object_names)

          # Create entity objects for each entity source file.
          entities = generate_entities(entity_files)

          # Import each entity.
          entities.each(&:import!)
        end

        private

        # Generate `Expando::SourceFiles::EntityFile` objects (and their
        # matching source files) for each entity that needs to be imported.
        #
        # @private
        #
        # @param [Array<String>] entity_names
        #   The names of the entity files to update.
        #
        # @return [Array<Expando::SourceFiles::EntityFile>]
        #   The generated file objects.
        def generate_entity_files(entity_names = [])
          Expando::Logger.log 'Generating entity source files'

          # TODO: High- handle error case
          # Fetch the list of entities.
          entities = client.get_entities_request

          # Import every entity if none specified.
          entity_names = entities.collect { |i| i[:name] } if entity_names.empty?

          # For every entity name...
          entity_names.collect do |entity_name|
            # Fetch the entity with a matching name.
            entity = entities.select { |i| i[:name] == entity_name }.first

            # Raise an error if an entity with this name can't be found.
            raise ArgumentError, "No entity with name #{entity_name} found" unless entity

            # ...generate a new source file path for the entity.
            entity_file_path = File.join(entities_path, "#{entity_name}.txt")

            # Create the entity file on the filesystem.
            FileUtils.touch(entity_file_path)

            # Create the entity file object.
            Expando::SourceFiles::EntityFile.new(entity_file_path, id: entity[:id])
          end
        end
      end
    end
  end
end
