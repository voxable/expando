module Expando
  module ApiAi
    module Objects
      # Encapsulates common behavior for all API.ai objects.
      class Base
        extend ::Dry::Initializer

        # !@attribute source_file
        #   @return [Expando::SourceFiles::IntentFile, Expando::SourceFiles::EntityFile]
        #     The Expando source file for this object.
        option :source_file

        # !@attribute api_client
        #   @return [VoxableApiAiRuby::Client] An API.ai API client for this project's agent.
        option :api_client

        private

          # Properly handle the response from API.ai.
          #
          # @param [Hash] response
          #   The response from `VoxableApiAiRuby::Client`.
          # @param [Symbol] type
          #   Either `:intent` or `:entity`, depending on what is
          #   being updated.
          # @return [void]
          def handle_response(response, type)
            begin
              if successful?(response)
                Expando::Logger.log_successful_update(type, @source_file.object_name)
              else
                Expando::Logger.log_failed_update(type, response)
              end
            rescue StandardError => e
              puts e.message
              puts e.backtrace.inspect

              abort(failed_update_message)
            end
          end

          # Determine if the query was successful.
          #
          # @param [Hash] response The raw response from API.ai
          # @return [Boolean] `true` if successful, `false` otherwise.
          def successful?(response)
            response && response[:status] && (response[:status][:code] == 200)
          end
      end
    end
  end
end
