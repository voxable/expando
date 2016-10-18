module Expando
  class ProjectTemplate
    class << self
      # Initialize a new Expando project in the current working directory.
      def init!
        mkdir 'intents'
        mkdir 'entities'
      end

      private

      # Attempt to create the specified directory. Output progress to user.
      #
      # @param directory [String] The directory to create.
      def mkdir(directory)
        full_path = File.join(Dir.pwd, directory)

        if Dir.exist?(full_path)
          puts '•'.colorize(:blue) + " #{directory} directory exists (skipping)"
        else
          Dir.mkdir(full_path)
          puts '✓'.colorize(:green) + " #{directory} directory created"
        end
      end
    end
  end
end
