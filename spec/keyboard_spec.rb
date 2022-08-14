RSpec.describe Keyboard do
  describe '.letter_rows' do
    it 'returns letters of a keyboard' do
      expect(described_class.letter_rows).to eq(
        [
          ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
          ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
          ['Z', 'X', 'C', 'V', 'B', 'N', 'M']
        ]
      )
    end
  end
end
