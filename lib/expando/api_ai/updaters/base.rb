module Expando::ApiAi
  module Updaters
    class Base
      extend ::Dry::Initializer

      # The default location of intent source files
      DEFAULT_INTENTS_PATH = File.join( Dir.pwd, 'intents')

      # The default location of entity source files
      DEFAULT_ENTITIES_PATH = File.join( Dir.pwd, 'entities' )

      # The default location of intent response source files
      DEFAULT_RESPONSES_PATH = File.join( Dir.pwd, 'responses' )

      # !@attribute object_names
      #   @return [Array<String>] The names of the objects to be updated.
      param :object_names, Expando::Types::Strict::Array, optional: true

      # !@attribute intents_path
      #   @return [String] The path to the directory containing the intent source
      #     files. (default: './intents')
      option :intents_path, Expando::Types::Strict::String,
             default: proc { DEFAULT_INTENTS_PATH }

      # !@attribute entities_path
      #   @return [String] The path to the directory containing the entity source
      #     files. (default: './entities')
      option :entities_path, Expando::Types::Strict::String,
             default: proc { DEFAULT_ENTITIES_PATH }

      # !@attribute responses_path
      #   @return [String] The path to the directory containing the intent response
      #     source files. (default: './responses')
      option :responses_path, Expando::Types::Strict::String,
             default: proc { DEFAULT_RESPONSES_PATH }

      # !@attribute developer_access_token
      #   @return [String] The Api.ai developer access token.
      option :developer_access_token, Expando::Types::Strict::String,
             default: proc { ENV['API_AI_DEVELOPER_ACCESS_TOKEN'] }

      # !@attribute client_access_token
      #   @return [String] The Api.ai client access token.
      option :client_access_token, Expando::Types::Strict::String,
             default: proc { ENV['API_AI_CLIENT_ACCESS_TOKEN'] }

      def update
        raise NotImplementedError, '#update must be overridden in subclass'
      end

      private

        # @return [APIAiRuby::Client] An API.ai API client for this project's agent.
        def client
          @client ||= ApiAiRuby::Client.new({
            client_access_token:    client_access_token,
            developer_access_token: developer_access_token
          })
        end

        # Properly handle the response from Api.ai.
        #
        # @param [Hash] response The response from `ApiAiRuby::Client`.
        # @param [Symbol] type Either `:intent` or `:entity`, depending on what is
        #   being updated.
        # @return [void]
        def handle_response(response, type)
          begin
            if successful?(response)
              Expando::Logger.log_successful_update(type)
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
        # @param [Hash] response The raw response from Api.ai
        # @return [Boolean] `true` if successful, `false` otherwise.
        def successful?(response)
          response && response[:status] && (response[:status][:code] == 200)
        end
    end
  end
end
