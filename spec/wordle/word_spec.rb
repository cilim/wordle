RSpec.describe Wordle::Word do
  subject(:word) { described_class.new(input) }

  describe '.new' do
    let(:input) { 'loose' }

    it 'returns object of self' do
      expect(word).to be_a(described_class)
    end

    it 'object of self if child of String' do
      expect(word).to be_a(String)
    end

    it 'upcases the string' do
      expect(word).to eq('LOOSE')
    end
  end

  describe '#target' do
    let(:input) { 'anything' }

    it 'instance variable target can be accessed' do
      word.target = :anything

      expect(word.target).to eq(:anything)
    end
  end

  describe '#hints' do
    before do
      word.target = target
    end

    context 'when input has 2 duplicate (O letters in this case) whereas target has 1' do
      let(:target) { 'SMOKE' }
      let(:input) { 'LOOSE' }

      it 'returns correct symbols' do
        expect(word.hints).to eq([:miss, :miss, :hit, :found, :hit])
      end
    end

    context 'when input has 3 duplicate (R letters in this case) whereas target has 2' do
      let(:target) { 'ROWER' }
      let(:input) { 'ERROR' }

      it 'returns correct symbols' do
        expect(word.hints).to eq([:found, :found, :miss, :found, :hit])
      end
    end

    context 'when input all the same letters as target but none match' do
      let(:target) { 'LISTEN' }
      let(:input) { 'ENLIST' }

      it 'returns correct symbols' do
        expect(word.hints).to eq([:found, :found, :found, :found, :found, :found])
      end
    end
  end
end
