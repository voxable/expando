require 'spec_helper'
require 'pathname'

describe Expando::ApiAi::Updaters::EntityUpdater do
  let(:entity_name)              { 'appliance' }
  let(:entity_names)             { [] }
  let(:entity_path)              { '/entities' }
  let(:entity_directory_entries) { ['.', '..', "#{entity_name}.txt", 'location.txt'] }
  let(:entity_object)            { instance_double(Expando::ApiAi::Objects::Entity) }
  let(:token)                    { 's0m3t0k3n' }
  let(:client)                   { double('client', update_entities_request: true) }

  subject {
    described_class.new(
      entity_names,
      entities_path: 'entities',
      developer_access_token: token,
      client_access_token: token
    )
  }

  before(:each) do
    allow(Dir).to receive(:entries).and_return(entity_directory_entries)
    allow(Expando::ApiAi::Objects::Entity).to receive(:new).and_return(entity_object)
    allow(entity_object).to receive(:update!)
  end

  describe '#update!' do
    context 'when specific entity names are passed' do
      let(:entity_names) { [entity_name] }

      it 'only updates the requested entities' do
        expect(entity_object).to receive(:update!).once

        subject.update!
      end
    end

    context 'when no entity names are passed' do
      let(:entity_names) { [] }

      it 'updates every entity in the entities directory' do
        expect(entity_object).to receive(:update!).twice

        subject.update!
      end
    end

    it "properly generates an API.ai client for this project's agent" do
      expect(VoxableApiAiRuby::Client).to receive(:new).with(hash_including({
        developer_access_token: token,
        client_access_token:    token
      })).and_return(double('client')).once

      subject.update!
    end
  end
end
