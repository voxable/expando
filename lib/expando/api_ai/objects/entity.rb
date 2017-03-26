module Expando::ApiAi::Objects
  # Initialized with a hash representing an existing API.ai entity, and the path
  # to an Expando file for that entity, generates the JSON for a new version of
  # the entity.
  #
  # @see https://docs.api.ai/docs/entities#entity-object
  class Entity < Base
    # !@attribute responses_file
    #   @return [Expando::SourceFiles::ResponsesFile]
    #     The Expando source file for this entity's responses.
    option :responses_file, optional: true, default: proc { nil }

    # Properly perform all Expando transformations (expansion) to the source for
    # the entity, generate a new version of the entity's JSON, and update it on API.ai.
    #
    # @return [void]
    def update!
      entity_json = [{ name: @source_file.entity_name, entries: expanded_entries }]

      response = @api_client.update_entities_request(entity_json)

      handle_response(response, :entity)
    end

    private

    # @return [Array<String>] The expanded list of entries and their synonyms.
    def expanded_entries
      sorted_entries.inject([]) do |entries, (entry_value, synonyms)|
        entries << {value: entry_value, synonyms: [entry_value] + synonyms}
      end
    end

    # @return [Hash] Properly sorted entries. Each key is the entry's name, and
    #   the value is the list of synonyms for that entry.
    def sorted_entries
      sorted = Hash.new([])

      processed_entities.each do |line|
        entry_value, *synonyms = *line.split(',').collect{ |s| s.strip }
        sorted[entry_value] = sorted[entry_value] + synonyms
      end

      sorted
    end

    # @return [Array<String>] The expanded list of entities.
    def processed_entities
      # For each line in the file...
      @source_file.lines.collect do |line|
        # ...split the entities by commas.
        entities = line.split(',')

        # Expand each entity example separately
        expanded_entities = Expando::Expander.expand! entities

        # Join the line back together
        expanded_entities.join(',')
      end
    end
  end
end
