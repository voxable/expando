module Expando::ApiAi::Updaters
  # Responsible for updating entity objects on Api.ai based on the contents of
  # files in `/entities`.
  class EntityUpdater < Base
    # !@attribute name
    #   @return [String] the name of the entity to be updated
    attr_accessor :name

    # !@attribute entities_path
    #   @return [String] the path to the directory containing the entities text files
    attr_accessor :entities_path

    # Initialize a new `EntityUpdater`.
    #
    # @see Updater#initialize
    def initialize( * )
      super
    end

    # Update the named entity on Api.ai.
    #
    # @return [Hash] if request successful. This is the response body.
    # @return [ApiAiRuby::RequestError] if request is in error.
    def update!
      entity = [{ name: @name.to_s, entries: expanded_entries }]

      response = @client.update_entities_request( entity )

      handle_response( response, :entity )
    end

    private

    # @return [Array<String>] The expanded list of entries and their synonyms.
    def expanded_entries
      sorted_entries.inject( [] ) do | entries, ( entry_value, synonyms ) |
        entries << { value: entry_value, synonyms: [ entry_value ] + synonyms }
      end
    end

    # @return [Hash] Properly sorted entries. Each key is the entry's name, and
    #   the value is the list of synonyms for that entry.
    def sorted_entries
      sorted = Hash.new( [] )

      expanded_entities.each do | line |
        entry_value, *synonyms = *line.split(',').collect{ |s| s.strip }
        sorted[ entry_value ] = sorted[ entry_value ] + synonyms
      end

      sorted
    end

    # @return [Array<String>] The expanded list of entities.
    def expanded_entities
      entity_file_path = File.join( File.expand_path( @entities_path ), "#{@name}.txt")
      Expando::Expander.expand! file_lines( entity_file_path )
    end
  end
end
