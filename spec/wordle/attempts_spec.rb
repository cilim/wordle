RSpec.describe Wordle::Attempts do
  subject(:attempts) { described_class.with_target(target) }

  let(:target) { 'TARGET' }

  describe '.with_target' do
    it 'returns a new object of self' do
      expect(attempts).to be_a(described_class)
    end

    it 'is a child of Array' do
      expect(attempts).to be_a(Array)
    end

    it 'sets target as instance variable' do
      expect(attempts.target).to eq(target)
    end
  end

  describe '#<<' do
    it 'adds a Wordle::Word object to self' do
      attempts << 'word'

      expect(attempts.last).to be_a(Wordle::Word)
    end

    it 'assigns target to Wordle::Word object in self' do
      attempts << 'word'

      expect(attempts.last.target).to eq(target)
    end
  end

  describe '#hints' do
    it 'returns mapped results of delegated hints method' do
      attempts << target

      expect(attempts.hints).to eq([[:hit, :hit, :hit, :hit, :hit, :hit]])
    end
  end

  describe '#used_letters' do
    it 'returns flat map of unique letters' do
      attempts << 'ABCD'
      attempts << 'DEFA'

      expect(attempts.used_letters).to eq(['A', 'B', 'C', 'D', 'E', 'F'])
    end
  end
end
