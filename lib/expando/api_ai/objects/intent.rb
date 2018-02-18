module Expando::ApiAi::Objects
  # Initialized with a hash representing an existing API.ai intent, and the path
  # to an Expando file for that intent, generates the JSON for a new version of
  # the intent.
  #
  # @see https://docs.api.ai/docs/intents#intent-object
  class Intent < Base
    # The list of attributes that can be removed from the intent JSON before updating.
    ATTRIBUTES_TO_REMOVE = %w{auto state priority webhookUsed lastUpdate fallbackIntent cortanaCommand}

    # !@attribute responses_file
    #   @return [Expando::SourceFiles::ResponsesFile]
    #     The Expando source file for this intent's responses.
    option :responses_file, default: proc { nil }

    # !@attribute entity_files
    #   @return [Array<Expando::SourceFiles::EntitiesFile>]
    #     The Expando entity source files.
    option :entity_files, default: proc { [] }

    # Properly perform all Expando transformations (expansion, annotation) to the
    # source for the intent, generate a new version of the intent's JSON, and update
    # it on API.ai.
    #
    # @return [void]
    def update!
      # Fetch the latest version of the intent from API.ai.
      intent_json = current_version

      # Replace the original utterances with the Expando-processed utterances, and
      # their new associated params.
      intent_json[:templates] = processed_utterances
      new_user_says, new_params = user_says_value(intent_json[:responses][0][:parameters])
      intent_json[:userSays] = new_user_says
      intent_json[:responses][0][:parameters] = new_params

      # Replace the responses, if a response file exists for this intent.
      intent_json[:responses][0][:messages][0][:speech] = responses if @responses_file

      # Clean up portions of the JSON response that we don't need in the request
      ATTRIBUTES_TO_REMOVE.each { |key| intent_json.delete(key.to_sym) }

      response = @api_client.update_intent_request(intent_json)

      handle_response(response, :intent)
    end

    private

    # Generate new user utterances based on the Expando source for this intent.
    #
    # @return [Array<Hash>] The new `userSays` attribute.
    def processed_utterances
      @processed_utterances ||= Expando::Expander.expand! @source_file.lines
    end

    # TODO: High- document, test, and decompose
    def user_says_value(existing_params)
      additional_params = Set.new(existing_params)

      new_user_says = processed_utterances.collect do |utterance|
        # If an entity is referenced on this line...
        if utterance.match(Expando::Tokens::ENTITY_REF_MATCHER)
          template = utterance.dup
          data = []

          # For every matching entity reference...
          utterance.scan(Expando::Tokens::ENTITY_REF_MATCHER).each do |entity_reference|
            entity_name, is_system_entity, last_letter, parameter_name = entity_reference

            param_data_type = "@#{entity_name}"
            param_value = "$#{parameter_name}"

            # Unless the param is already in the list...
            unless additional_params.select { |p| p[:name] == parameter_name }.first
              # ...add the new param to the list of params.
              additional_params << {
                dataType: param_data_type,
                name: parameter_name,
                value: param_value,
                isList: false
              }
            end

            # Find a random value to use for the entity.
            example_entity_value = example_entity_value(entity_name, is_system_entity)

            # Add data entries.
            data << { text: template.match(Expando::Tokens::UNTIL_ENTITY_REF_MATCHER)[0] }
            data << {
              text: example_entity_value,
              alias: parameter_name,
              meta: "@#{entity_name}"
            }

            # Remove the processed portions from the template string
            template.sub!(Expando::Tokens::UNTIL_ENTITY_REF_MATCHER, '')
            template.sub!(Expando::Tokens::ENTITY_REF_MATCHER, '')
          end

          # Add everything that remains.
          data << {
            text: template
          }

          {
            data: data,
            isTemplate: false
          }
        else
          {
            data: [
              text: utterance
            ],
            # TODO: Make this an option
            isTemplate: false
          }
        end
      end

      [new_user_says, additional_params.to_a]
    end

    # Find a random value for the given entity.
    #
    # @param entity_name [String] The name of the entity.
    # @param is_system_entity [Boolean] true if this is an API.ai system entity.
    #
    # @return [String] The random entity value.
    def example_entity_value(entity_name, is_system_entity)
      # If this is a system entity...
      if is_system_entity
        # ...grab a random canonical value for the entity.

        Expando::ApiAi::SystemEntityExamples::VALUES[entity_name].sample

        # If this is a developer entity...
      else
        # ...find a matching entity file.
        # TODO: High - throw an error if none.
        entity_file =
          @entity_files
            .select { |entity_file| entity_file.entity_name == entity_name }
            .first

        # Grab a random canonical value for the entity.
        entity_file.random_canonical_value
      end
    end

    # Generate new responses for this intent based on the Expando responses source.
    #
    # @return [Array<String>] The new responses.
    def responses
      return false unless @responses_file

      Expando::Expander.expand! @responses_file.lines
    end

    # Fetch the existing intent with this name on API.ai.
    #
    # @return [Hash] The current version of the intent object on API.ai.
    def current_version
      @@intents ||= @api_client.get_intents_request

      matching_intent = @@intents.select { |intent| intent[:name] == @source_file.intent_name }

      # TODO: needs an exception class
      raise "There is no intent named #{@source_file.intent_name}" if matching_intent.empty?

      intent_id = matching_intent.first[:id]

      Expando::Logger.log "Fetching latest version of #{@source_file.intent_name} intent"
      @api_client.get_intent_request(intent_id)
    end
  end
end
