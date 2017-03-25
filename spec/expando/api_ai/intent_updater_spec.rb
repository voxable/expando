require 'spec_helper'
require 'pathname'

describe Expando::ApiAi::IntentUpdater do
  before(:each) do
    #get_intents_response = JSON.parse( File.read( File.join( intents_fixture_dir, 'requests/get_intents.json' ) ), symbolize_names: true )
    #get_intent_response = JSON.parse( File.read( File.join( intents_fixture_dir, 'requests/get_intent.json' ) ), symbolize_names: true )

    #@client = double('client')
    #allow( ApiAiRuby::Client ).to receive( :new ).with( anything() ).and_return( @client )
    #allow( @client ).to receive( :update_intent_request )
    #allow( @client ).to receive( :get_intents_request ).and_return( get_intents_response )
    #allow( @client ).to receive( :get_intent_request ).with( anything() ).and_return( get_intent_response )
  end

  describe '#update!' do
    context 'when specific intent names are passed' do
      it 'only updates the requested intents'
    end

    context 'when no intent names are passed' do
      it 'updates every intent in the intents directory'
    end
  end

=begin

  describe '#update!' do
    subject { Expando::ApiAi::IntentUpdater.new( :launchScan, intents_path: intents_fixture_dir ) }
    let(:intent_json_fixture_path) { File.join( intents_fixture_dir, 'launchScan.json' ) }

    it 'opens the proper txt file in /intents' do
      allow( File ).to receive( :read ).and_call_original
      subject.update!

      expect( File ).to have_received( :read ).with( File.join(intents_fixture_dir, 'launchScan.txt' ) )
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
