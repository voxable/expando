module Expando
  # Print messages to the console.
  #
  # @example
  #   Expando::Logger.log 'Fetching intents'
  module Logger
    module_function

    # Log a message.
    #
    # @param [String] message The message.
    # @return [void]
    def log(message)
      puts '• '.colorize(:blue) + message
    end

    # Log a successful update message.
    #
    # @param [Symbol] type The type of update (`:entity` or `:intent`).
    # @param [String] name The name of the object that was updated.
    #
    # @return [void]
    def log_successful_update(type, name)
      puts "• ".colorize(:blue) + "#{name} #{type} successfully updated!".colorize(:green)
      puts "Expando:".colorize(:magenta) + " Dialogflow agent updated.\n\n"
    end

    # Log a failed update message.
    #
    # @param [Symbol] type The type of update (`:entity` or `:intent`).
    # @param [Hash] response The API response.
    #
    # @return [String] The failed update message.
    def log_failed_update(type, response)
      '• '.colorize(:blue) + "#{@name} #{type} update failed:".colorize(:red)
      ap(response)
    end
  end
end
