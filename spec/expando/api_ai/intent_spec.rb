require 'spec_helper'

describe Expando::ApiAi::Objects::Intent, mock_logger: true do
  let(:get_intents_response) {
    JSON.parse(File.read(File.join(intents_fixture_dir, 'requests/get_intents.json')), symbolize_names: true)
  }

  let(:get_intent_response) {
    JSON.parse(File.read(File.join(intents_fixture_dir, 'requests/get_intent.json')),
               symbolize_names: true)
  }

  let(:intent_json_fixture_path) { File.join( intents_fixture_dir, 'launchScan.json' ) }

  let(:source_file) {
    instance_double(
      Expando::SourceFiles::IntentFile,
      source_path: '/intents/launchScan.txt'
    )
  }

  let(:client) { double('client') }

  subject {
    described_class.new(
      source_file: source_file,
      api_client:  client
    )
  }

  before(:each) do
    allow(ApiAiRuby::Client).to receive(:new).with(anything()).and_return(@client)
    allow(client).to receive(:update_intent_request)
    allow(client).to receive(:get_intents_request).and_return(get_intents_response)
    allow(client).to receive(:get_intent_request).with(anything()).and_return(get_intent_response)
  end

  describe '#update!' do
    it "fetches the latest version of the intent's JSON from API.ai" do
      launch_scan_intent = JSON.parse(File.read(intent_json_fixture_path))
      subject.update!

      expect(client).to have_received(:get_intent_request).with(launch_scan_intent['id'])
    end
  end
end
