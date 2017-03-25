require 'spec_helper'
require 'pathname'

describe Expando::ApiAi::Updaters::IntentUpdater do
  let(:intent_name) { 'updateStatus' }
  let(:intent_names) { nil }
  let(:intent_path) { '/intents' }
  let(:intent_directory_entries) { ['.', '..', "#{intent_name}.txt", 'removeStatus.txt'] }
  let(:intent_object) { instance_double(Expando::ApiAi::Objects::Intent) }

  subject {
    Expando::ApiAi::Updaters::IntentUpdater.new(
      intent_names,
      intents_path: 'intents',
      developer_access_token: 'sometoken',
      client_access_token: 'sometoken'
    )
  }

  before(:each) do
    allow(Dir).to receive(:entries).and_return(intent_directory_entries)
    allow(Expando::ApiAi::Objects::Intent).to receive(:new).and_return(intent_object)
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
  end

  it "properly generates an API.ai client for this project's agent"
end
