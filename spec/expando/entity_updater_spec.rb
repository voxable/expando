require 'spec_helper'
require 'pathname'

describe Expando::EntityUpdater do
  subject { Expando::EntityUpdater.new( :appliances ) }

  before(:each) do
    @client = double('client')
    allow( ApiAiRuby::Client ).to receive( :new ).with( anything() ).and_return( @client )
    allow( @client ).to receive( :update_entities_request )
  end

  describe '#initialize' do
    it 'sets the name attribute to the value of the first argument' do
      expect( subject.name ).to eq( :appliances )
    end

    context 'when setting the entities directory' do
      it 'sets a proper default location for entity files' do
        default_entity_dir = Pathname.new( File.join( File.dirname( __FILE__ ), '../../entities' ) ).realpath.to_s

        expect( Pathname.new( subject.entities_dir ).realpath.to_s ).to eq( default_entity_dir )
      end

      it 'allows overriding the location for entity files' do
        test_entities_dir = entities_fixture_dir
        updater = Expando::EntityUpdater.new :appliances, entities_dir: test_entities_dir

        expect( updater.entities_dir ).to eq( test_entities_dir )
      end
    end

    include_examples 'building the Api.ai client'
  end

  describe '#update!' do
    subject { Expando::EntityUpdater.new( :appliances, entities_dir: entities_fixture_dir ) }

    it 'opens the proper file in /entities' do
      allow( File ).to receive( :read ).and_call_original
      subject.update!

      expect( File ).to have_received( :read ).with( File.join(entities_fixture_dir, 'appliances.txt' ) )
    end

    it 'constructs a proper entities object for the Api.ai API call' do
      appliance_entity = [
          {
              name: 'appliances',
              entries: [
                  {

                      value: 'coffee maker',
                      synonyms: [
                          'coffee maker',
                          'coffee'
                      ]
                  },
                  {
                      value: 'thermostat',
                      synonyms: [
                          'thermostat',
                          'heat',
                          'air conditioning'
                      ]
                  },
                  {
                      value: 'lights',
                      synonyms: %w(lights light lamps)
                  },
                  {
                      value: 'garage door',
                      synonyms: [
                          'garage door',
                          'garage'
                      ]
                  }
              ]
          }
      ]

      subject.update!

      expect( @client ).to have_received( :update_entities_request ).with( appliance_entity )
    end

    context 'when expansion tokens are present in the entity source' do
      subject { Expando::EntityUpdater.new( :appliancesWithExpansion, entities_dir: entities_fixture_dir ) }

      it 'constructs a proper entities object for the Api.ai API call' do
        appliance_entity = [
            {
                name: 'appliancesWithExpansion',
                entries: [
                    {

                        value: 'coffee maker',
                        synonyms: [
                            'coffee maker',
                            'coffee machine',
                            'coffee pot'
                        ]
                    },
                    {
                        value: 'thermostat',
                        synonyms: [
                            'thermostat',
                            'heat',
                            'air conditioning',
                            'ac'
                        ]
                    },
                    {
                        value: 'lights',
                        synonyms: %w(lights light lamps)
                    },
                    {
                        value: 'garage door',
                        synonyms: [
                            'garage door',
                            'garage doors',
                            'garage opener'
                        ]
                    }
                ]
            }
        ]

        subject.update!

        expect( @client ).to have_received( :update_entities_request ).with( appliance_entity )
      end
    end
  end
end