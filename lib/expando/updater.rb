module Expando
  class Updater
    # The default location of intent source files
    DEFAULT_INTENTS_DIR = File.join( File.dirname( __FILE__ ), '../../intents')

    # The default location of entity source files
    DEFAULT_ENTITIES_DIR = File.join( File.dirname( __FILE__ ), '../../entities' )

    # Initialize a new `Updater`.
    #
    # @param [Symbol] name The name of the intent or entity to update. (default: `nil`)
    # @param [String] entities_dir The path to the directory containing the
    #   entities text files. (default: `'entities'`)
    # @param [String] intents_dir The path to the directory containing the
    #   intents source files. (default: 'intents')
    # @param [Hash] client_keys A hash of Api.ai credentials.
    # @option client_keys [String] :developer_access_token The Api.ai developer
    #   access token.
    # @option client_keys [String] :client_access_token The Api.ai client access
    #   token.
    # @return [Updater] The new `Updater`.
    def initialize( name = nil, intents_dir: DEFAULT_INTENTS_DIR, entities_dir: DEFAULT_ENTITIES_DIR, client_keys: {})
      @name = name
      @intents_dir = intents_dir
      @entities_dir = entities_dir

      @client = ApiAiRuby::Client.new( credentials( client_keys ) )
    end

    private

    # Generate a credentials hash for Api.ai from environment variables or passed
    # arguments, whichever is provided.
    #
    # @param [Hash] client_keys A hash of Api.ai credentials.
    # @option client_keys [String] :developer_access_token The Api.ai developer
    #   access token.
    # @option client_keys [String] :client_access_token The Api.ai client access
    #   token.
    # @return [Hash] The Api.ai client credentials.
    def credentials(client_keys)
      developer_access_token = ENV['API_AI_DEVELOPER_ACCESS_TOKEN'] || client_keys[:developer_access_token]
      client_access_token = ENV['API_AI_CLIENT_ACCESS_TOKEN'] || client_keys[:client_access_token]

      {
          client_access_token: client_access_token,
          developer_access_token: developer_access_token,
      }
    end

    # Properly handle the response from Api.ai.
    #
    # @param [Hash] response The response from `ApiAiRuby::Client`.
    # @param [Symbol] type Either `:intent` or `:entity`, depending on what is
    #   being updated.
    # @return [void]
    def handle_response( response, type )
      begin
        if successful?( response )
          log_completion_message(type )
        else
          puts failed_update_message(type )
          ap response
        end
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect

        abort( failed_update_message )
      end
    end

    # Determine if the query was successful.
    #
    # @param [Hash] response The raw response from Api.ai
    # @return [Boolean] `true` if successful, `false` otherwise.
    def successful?( response )
      response && response[ :status ] && ( response[ :status ][ :code ] == 200 )
    end

    # Generate a failed entity update message.
    #
    # @param [Symbol] type The type of update (`:entity` or `:intent`).
    # @return [String] The failed update message.
    def failed_update_message( type )
      '• '.colorize( :blue ) + "#{ @name } #{ type.to_s } update failed:".colorize(:red )
    end

    # Output a log message.
    #
    # @param [String] The message.
    # @return [void]
    def log_message( message )
      puts '• '.colorize( :blue ) + message
    end

    # Output a successful update message.
    #
    # @param [Symbol] type The type of update (`:entity` or `:intent`).
    # @return [void]
    def log_completion_message( type )
      puts "• ".colorize( :blue ) + "#{ @name } #{ type.to_s } successfully updated!".colorize( :green )
      puts "\nExpando:".colorize( :magenta ) + " Api.ai agent updated."
    end

    # Read a file into an array of strings.
    #
    # @param [String] file_path The path to the file to convert.
    # @return [Array<String>] An array of all of the lines in the file.
    def file_lines( file_path )
      File.read( file_path ).lines.collect{ |line| line.chomp }
    end
  end
end