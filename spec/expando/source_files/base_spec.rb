require 'spec_helper'

describe Expando::SourceFiles::Base do
  let(:intent_name)        { 'launchScan' }
  let(:intent_source_path) { intent_fixture_file_path(intent_name) }

  subject {
    described_class.new(intent_source_path)
  }

  describe '#lines' do
    it 'returns all of the lines in the file as an array' do
      expect(subject.lines.count).to eq(File.read(intent_source_path).lines.count)
    end
  end

  describe '#object_name' do
    it 'returns the name of the associated intent or entity for this source file' do
      expect(subject.object_name).to eq(intent_name)
    end
  end
end
