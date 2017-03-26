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
        'launch a @scan:scanName',
        'run a @scan:scanName'
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

  before(:each) do
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

    context 'when no intent with the same name is found on Api.ai' do
      it 'throws an error' do
        allow(source_file).to receive(:intent_name).and_return('foobar')

        expect{ subject.update! }.to raise_error(RuntimeError, 'There is no intent named foobar')
      end
    end

    # TODO: Making this pass required changing get_intent.json so that it's no longer
    # compatible with actual requests. Fix that.
=begin
    pending 'constructs proper templates for the Api.ai API call' do
      launch_scan_intent = JSON.parse( File.read( intent_json_fixture_path ), symbolize_names: true )
      utterances = [ 'launch a @scan:scanName', 'run a @scan:scanName' ]
      launch_scan_intent[ :templates ] = utterances
      subject.update!
      expect( @client ).to have_received( :update_intent_request ).with( launch_scan_intent )
    end
    # TODO: Same problem as above. Shouldn't be checking this against the get request fixture.
    # Create a new fixture for comparison.
    context 'when expansion tokens are present in the intent source' do
      subject { Expando::IntentUpdater.new( :launchScanWithExpansion, intents_path: intents_fixture_dir ) }
      it 'constructs a proper templates for the Api.ai API call' do
        launch_scan_intent = JSON.parse( File.read( intent_json_fixture_path ), symbolize_names: true )
        utterances = [
            'launch @scan:scanName',
            'run @scan:scanName',
            'open @scan:scanName'
        ]
        launch_scan_intent[ :templates ] = utterances
        subject.update!
        expect( @client ).to have_received( :update_intent_request ).with( launch_scan_intent )
      end
    end
=end
  end
end
