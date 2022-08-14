RSpec.describe Dictionary do
  describe '.words' do
    it 'returns array of strings' do
      expect(described_class.words).to all(be_a(String))
    end

    it 'returns 5757 words' do
      expect(described_class.words.size).to eq(5757)
    end
  end

  describe '.random_pick' do
    it 'returns a different word every time' do
      expect(described_class.random_pick).not_to eq(described_class.random_pick) # flaky spec ahead!!
    end
  end

  describe '.include?' do
    context 'when word not in dictionary' do
      it 'returns false' do
        expect(described_class.include?('SNAZY')).to eq(false)
      end
    end

    context 'when word in dictionary' do
      it 'returns true' do
        expect(described_class.include?('WATER')).to eq(true)
      end
    end

    context 'when word lowercased' do
      it 'raises error' do
        expect { described_class.include?('water') }.to raise_error(RuntimeError)
      end
    end
  end
end
