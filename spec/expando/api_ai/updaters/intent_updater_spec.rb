require 'spec_helper'
require 'pathname'

describe Expando::ApiAi::Updaters::IntentUpdater do
  let(:intent_name)              { 'updateStatus' }
  let(:intent_names)             { [] }
  let(:intent_path)              { '/intents' }
  let(:intent_directory_entries) { ['.', '..', "#{intent_name}.txt", 'removeStatus.txt'] }
  let(:intent_object)            { instance_double(Expando::ApiAi::Objects::Intent) }
  let(:token)                    { 's0m3t0k3n' }

  subject {
    described_class.new(
      intent_names,
      intents_path: 'intents',
      developer_access_token: token,
      client_access_token: token
    )
  }

  before(:each) do
    allow(Dir).to receive(:entries).and_return(intent_directory_entries)
    allow(Expando::ApiAi::Objects::Intent).to receive(:new).and_return(intent_object)
    allow(intent_object).to receive(:update!)
  end

  describe '#update!' do
    context 'when specific intent names are passed' do
      let(:intent_names) { [intent_name] }

      it 'only updates the requested intents' do
        expect(intent_object).to receive(:update!).once

        subject.update!
      end
    end

    context 'when no intent names are passed' do
      let(:intent_names) { [] }

      it 'updates every intent in the intents directory' do
        expect(intent_object).to receive(:update!).twice

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
