module Expando
  class ProjectTemplate
    class << self
      # Initialize a new Expando project in the current working directory.
      def init!
        mkdir 'intents'
        mkdir 'entities'

        config_file_contents = <<-CONFIG_FILE
# API.AI credentials - add the credentials for your agent below
:client_access_token: REPLACE_WITH_TOKEN
:developer_access_token: REPLACE_WITH_TOKEN
        CONFIG_FILE

        mkfile '.expando.rc.yaml', config_file_contents

        circleci_config_file_contents = <<-CIRCLECI_CONFIG_FILE
deployment:
  staging:
    branch: /.*/
    commands:
      - bundle exec ./bin/expando update intents
      - bundle exec ./bin/expando update entities
        CIRCLECI_CONFIG_FILE

        mkfile 'circle.yaml', circleci_config_file_contents
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

      # Attempt to create the specified file. Output progress to user.
      #
      # @param name [String] The name of the file.
      # @param contents [String] The contents of the file.
      def mkfile(name, contents)
        full_path = File.join(Dir.pwd, name)

        if File.exist?(name)
          puts '•'.colorize(:blue) + " #{name} file exists (skipping)"
        else
          File.open(full_path, 'w') do |file|
            file << contents
          end
          puts '✓'.colorize(:green) + " #{name} file created"
        end
      end
    end
  end
end
