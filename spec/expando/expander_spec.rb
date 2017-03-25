require 'spec_helper'

describe Expando::Expander do
  let(:lines) { [ '(I|we|they) heard you (love|hate) (cars|boats|bikes)' ] }
  let(:expanded_lines) {
    [
      'I heard you love cars',
      'I heard you love boats',
      'I heard you love bikes',
      'I heard you hate cars',
      'I heard you hate boats',
      'I heard you hate bikes',
      'we heard you love cars',
      'we heard you love boats',
      'we heard you love bikes',
      'we heard you hate cars',
      'we heard you hate boats',
      'we heard you hate bikes',
      'they heard you love cars',
      'they heard you love boats',
      'they heard you love bikes',
      'they heard you hate cars',
      'they heard you hate boats',
      'they heard you hate bikes',
    ]
  }

  it 'properly expands the tokenized text' do
    expect( Expando::Expander.expand!( lines ) ).to eq( expanded_lines )
  end

  context 'when some lines are commented out' do
    let(:lines) {
      [
        '# this is a comment',
        '(I|we|they) heard you (love|hate) (cars|boats|bikes)'
      ]
    }

    it 'properly expands the tokenized text, ignoring the commented lines' do
      expect( Expando::Expander.expand!( lines ) ).to eq( expanded_lines )
    end
  end
end
