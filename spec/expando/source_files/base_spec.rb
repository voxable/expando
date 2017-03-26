require 'spec_helper'

describe Expando::SourceFiles::Base do
  let(:intent_source_path) { intent_fixture_file_path('launchScan') }

  subject {
    described_class.new(intent_source_path)
  }

  describe '#lines' do
    it 'returns all of the lines in the file as an array' do
      expect(subject.lines.count).to eq(File.read(intent_source_path).lines.count)
    end
  end
end
