require 'spec_helper'
require 'pathname'

describe Expando::ApiAi::IntentUpdater do
  subject { Expando::ApiAi::IntentUpdater.new( :launchScan ) }

  before(:each) do
    get_intents_response = JSON.parse( File.read( File.join( intents_fixture_dir, 'requests/get_intents.json' ) ), symbolize_names: true )
    get_intent_response = JSON.parse( File.read( File.join( intents_fixture_dir, 'requests/get_intent.json' ) ), symbolize_names: true )

    @client = double('client')
    allow( ApiAiRuby::Client ).to receive( :new ).with( anything() ).and_return( @client )
    allow( @client ).to receive( :update_intent_request )
    allow( @client ).to receive( :get_intents_request ).and_return( get_intents_response )
    allow( @client ).to receive( :get_intent_request ).with( anything() ).and_return( get_intent_response )
  end

  describe '#initialize' do
    it 'sets the name attribute to the value of the first argument' do
      expect( subject.name ).to eq( :launchScan )
    end

    context 'when setting the intents directory' do
      it 'sets a proper default location for intent source files' do
        DEFAULT_INTENTS_PATH = File.join( Dir.pwd, 'intents' )

        expect( subject.intents_path ).to eq( DEFAULT_INTENTS_PATH )
      end

      it 'allows overriding the location for intent source files' do
        test_intents_path = intents_fixture_dir
        updater = Expando::ApiAi::IntentUpdater.new :launchScan, intents_path: test_intents_path

        expect( updater.intents_path ).to eq( test_intents_path )
      end
    end

    include_examples 'building the Api.ai client'
  end

  describe '#update!' do
    subject { Expando::ApiAi::IntentUpdater.new( :launchScan, intents_path: intents_fixture_dir ) }
    let(:intent_json_fixture_path) { File.join( intents_fixture_dir, 'launchScan.json' ) }

    it 'opens the proper txt file in /intents' do
      allow( File ).to receive( :read ).and_call_original
      subject.update!

      expect( File ).to have_received( :read ).with( File.join(intents_fixture_dir, 'launchScan.txt' ) )
    end

    it 'properly sets the id of the intent for the Api.ai API call' do
      launch_scan_intent_id = '1dbfe740-2fbd-4c5e-95ef-0b3090fda942'

      subject.update!
      expect( @client ).to have_received( :update_intent_request ).with( hash_including( id: launch_scan_intent_id ) )
    end

    context 'when no intent with the same name is found on Api.ai' do
      it 'throws an error' do
        subject.name = 'foobar'

        expect{ subject.update! }.to raise_error(RuntimeError, "There is no intent named foobar")
      end
    end

    it "fetches the latest version of the intent's JSON" do
      launch_scan_intent = JSON.parse( File.read( intent_json_fixture_path ) )
      subject.update!

      expect( @client ).to have_received( :get_intent_request ).with( launch_scan_intent[ 'id' ] )
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
      subject { Expando::ApiAi::IntentUpdater.new( :launchScanWithExpansion, intents_path: intents_fixture_dir ) }

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
