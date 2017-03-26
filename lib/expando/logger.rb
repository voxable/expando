module Expando
  # Print messages to the console.
  #
  # @example
  #   Expando::Logger.log 'Fetching intents'
  module Logger
    module_function

    # Output a log message.
    #
    # @param [String] The message.
    # @return [void]
    def log( message )
      puts '• '.colorize( :blue ) + message
    end
  end
end
