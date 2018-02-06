module Expando::ApiAi::Objects
  # Initialized with a hash representing an existing API.ai entity, and
  # (optionally) the path to an Expando file for that entity, can either
  # generate the JSON for a new version of the entity or import the existing
  # entity to an Expando source file.
  #
  # @see https://docs.api.ai/docs/entities#entity-object
  class Entity < Base
    # !@attribute responses_file
    #   @return [Expando::SourceFiles::ResponsesFile]
    #     The Expando source file for this entity's responses.
    option :responses_file, default: proc { nil }

    # Properly perform all Expando transformations (expansion) to the source for
    # the entity, generate a new version of the entity's JSON, and update it on API.ai.
    #
    # @return [void]
    def update!
      entity_json = [{ name: @source_file.entity_name, entries: expanded_entries }]

      response = @api_client.update_entities_request(entity_json)

      handle_response(response, :entity)
    end

    # Import the existing entity into an Expando source file.
    def import!
      # Fetch the latest version of the entity from API.ai.
      entity_json = current_version

      # For each entry...
      source_lines =
        entity_json[:entries].collect do |entry|
          # Generate a new source line.
          line = entry[:synonyms].join(', ')
        end

      Expando::Logger.log "Generating source file for #{source_file.entity_name} entity"

      # Write the new Expando source to the intent file.
      File.open(source_file.source_path, 'w') do |f|
        f.puts(source_lines)
      end
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

    # Fetch the existing entity with this name on Dialogflow.
    #
    # @return [Hash]
    #   The current version of the entity object on Dialogflow.
    def current_version
      @retries = 1
      begin
        @api_client.get_entity_request(@id)
      rescue HTTP::Error => e
        # Periodically, these requests will fail with "Unknown mime type: text/plain"
        if @retries < 3
          @retries += 1
          current_version
        else
          puts e.inspect
          puts e.backtrace
        end
      end
    end
  end
end
