require 'spec_helper'

describe Expando::ApiAi::Objects::Intent, mock_logger: true do
  let(:get_intents_response) {
    JSON.parse(File.read(File.join(intents_fixture_dir, 'requests/get_intents.json')), symbolize_names: true)
  }

  let(:get_intent_response) {
    JSON.parse(File.read(File.join(intents_fixture_dir, 'requests/get_intent.json')),
               symbolize_names: true)
  }

  let(:intent_json_fixture_path) { intent_fixture_file_path('launchScan') }

  let(:source_file) {
    instance_double(
      Expando::SourceFiles::IntentFile,
      source_path: '/intents/launchScan.txt',
      lines: [
        '(launch|run) a scan',
        'scan now'
      ],
      intent_name: 'launchScan'
    )
  }

  let(:client) { double('client') }

  subject {
    described_class.new(
      source_file: source_file,
      api_client:  client
    )
  }

  before(:example) do
    allow(ApiAiRuby::Client).to receive(:new).with(anything()).and_return(@client)
    allow(client).to receive(:update_intent_request)
    allow(client).to receive(:get_intents_request).and_return(get_intents_response)
    allow(client).to receive(:get_intent_request).with(anything()).and_return(get_intent_response)
  end

  describe '#update!' do
    it "fetches the latest version of the intent's JSON from API.ai" do
      subject.update!

      expect(client).to have_received(:get_intent_request).with(get_intent_response[:id])
    end

    context 'when no intent with the same name is found on API.ai' do
      it 'throws an error' do
        allow(source_file).to receive(:intent_name).and_return('foobar')

        expect{ subject.update! }.to raise_error(RuntimeError, 'There is no intent named foobar')
      end
    end

    context 'when entities are referenced' do
      # TODO: High - test
      it 'properly annotates the entities'
    end

    # TODO: High - Resurrect the specs from before the refactor.
  end
end
