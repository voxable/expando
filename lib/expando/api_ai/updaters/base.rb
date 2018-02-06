module Expando::ApiAi
  module Updaters
    class Base < Expando::ApiAi::CommandBase

      def update
        raise NotImplementedError, '#update must be overridden in subclass'
      end

      private

      # Generate `Expando::SourceFiles::EntityFile` objects for each entity matching
      #   the passed `entity_names`, or for all entities in the directory if none passed.
      #
      # @param [Array<String>] entity_names The names of the entity files to update.
      #
      # @return [Array<Expando::SourceFiles::EntityFile>] The generated file objects.
      def generate_entity_files(entity_names = [])
        # TODO: Throw an error when a non-existing entity is requested.

        # Get a list of all entity file names.
        entity_file_names = Dir.entries(entities_path)[2..-1]

        # Reduce the list of entity source file names only to those that
        # match the requested entities.
        entity_file_names.reject! do |file_name|
          entity_file_base_name = File.basename(file_name, '.*')
          !entity_names.include?(entity_file_base_name)
        end unless entity_names.empty?

        # Generate an array of full file paths to the requested entity source files.
        entity_file_paths = entity_file_names.collect { |name| File.join(entities_path, name) }

        # Generate a list of Expando::SourceFiles::EntityFile objects for each entity.
        entity_file_paths.collect { |path| Expando::SourceFiles::EntityFile.new(path) }
      end
    end
  end
end
