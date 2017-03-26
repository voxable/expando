RSpec.shared_context 'with mocked logger' do
  before(:example) do
    allow(Expando::Logger).to receive(:log)
  end
end
