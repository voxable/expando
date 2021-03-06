require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'expando'
require 'rspec'

require 'support/shared_contexts/mocked_logger'

RSpec.configure do |config|
  # Shared contexts
  config.include_context 'with mocked logger', :mock_logger => true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# @return [String] the base fixtures directory
def fixture_path
  File.join(File.dirname(__FILE__), 'support', 'fixtures')
end

# Generate the proper path to the directory of entity fixtures.
#
# @return [String] The fixtures directory path.
def entities_fixture_dir
  File.join(fixture_path, 'entities')
end

# Generate the proper path to the directory of intents fixture files.
#
# @return [String] The fixtures directory path.
def intents_fixture_dir
  File.join(fixture_path, 'intents')
end

# Return a file for the Expando intent source fixture file with the given name.
#
# @param [String] intent_name The name of the intent.
#
# @return [String] The Expando source fixture file path.
def intent_fixture_file_path(intent_name)
  File.join(intents_fixture_dir, "#{intent_name}.txt")
end

