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
        #   @return [ApiAiRuby::Client] An API.ai API client for this project's agent.
        option :api_client
      end
    end
  end
end
