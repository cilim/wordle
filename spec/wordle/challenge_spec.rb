RSpec.describe Wordle::Challenge do
  let(:target) { 'smoke' }
  let(:challenge) { described_class.new(target) }

  describe '#target' do
    it 'returns target value' do
      expect(challenge.target).to eq(target)
    end
  end

  describe '#attempts' do
    context 'when no attempts made' do
      it 'returns attempts' do
        expect(challenge.attempts).to eq([])
      end
    end

    context 'when attempts present' do
      it 'returns attempts' do
        challenge.guess('loose')
        challenge.guess('smote')

        expect(challenge.attempts).to eq(['loose', 'smote'])
      end
    end
  end

  describe '#guess' do
    it 'adds attempt to attempts' do
      expect { challenge.guess('loose') }.to change(challenge, :attempts).from([]).to(['loose'])
    end

    context 'when word is same as target' do
      it 'returns true' do
        expect(challenge.guess(target)).to be_truthy
      end
    end

    context 'when word is different than target' do
      it 'returns false' do
        expect(challenge.guess('smote')).to be_falsey
      end
    end

    context 'when attempts maxed out' do
      it 'returns false' do
        6.times { challenge.guess('loose') }

        expect { challenge.guess(target) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#ended?' do
    context 'when attempts less than max attempts and target found' do
      it 'returns true' do
        challenge.guess(target)

        expect(challenge.ended?).to eq true
      end
    end

    context 'when attempts less than max attempts and target not found' do
      it 'returns false' do
        challenge.guess('smote')

        expect(challenge.ended?).to eq false
      end
    end

    context 'when attempts same as max attempts and target found' do
      it 'returns true' do
        5.times { challenge.guess('loose') }

        challenge.guess(target)

        expect(challenge.ended?).to eq true
      end
    end

    context 'when attempts same as max attempts and target not found' do
      it 'returns true' do
        6.times { challenge.guess('loose') }

        expect(challenge.ended?).to eq true
      end
    end
  end

  describe '#last_attempt' do
    it 'returns last attempt' do
      challenge.guess('pious')
      challenge.guess(target)

      expect(challenge.last_attempt).to eq(target)
    end
  end

  describe '#message' do
    context 'when challenge in progress' do
      it 'returns Challenge in progress' do
        challenge.guess('pious')

        expect(challenge.message).to eq('Challenge in progress')
      end
    end

    context 'when challenge ended' do
      it 'returns Won if attempts include target' do
        challenge.guess(target)

        expect(challenge.message).to eq('You won in 1! 🎉')
      end

      it 'returns Lost if attempts without target' do
        6.times { challenge.guess('loose') }

        expect(challenge.message).to eq('You lost! Target was: SMOKE 😓')
      end
    end
  end

  describe '#hints' do
    let(:target) { 'XXXXX' }

    it 'returns hints for all attempts' do
      challenge.guess('XXXXY')
      challenge.guess('YYYYX')

      expect(challenge.hints).to eq(
        [
          [:hit, :hit, :hit, :hit, :miss],
          [:miss, :miss, :miss, :miss, :hit]
        ]
      )
    end

    context 'when attempt has duplicate letters, first found then hit, but target only has 1 letter' do
      let(:target) { 'smoke' }

      it 'flags first duplicate letter as miss and the second as hit' do
        challenge.guess('loose')

        expect(challenge.hints).to eq([[:miss, :miss, :hit, :found, :hit]])
      end
    end

    context 'when attempt has duplicate letters, both only found, and target has 2 same letters' do
      let(:target) { 'oopsy' }

      it 'flags first duplicate letter as found and second as found' do
        challenge.guess('stood')

        expect(challenge.hints).to eq([[:found, :miss, :found, :found, :miss]])
      end
    end

    context 'when attempt has all misses' do
      let(:target) { 'XXXXX' }

      it 'flags all as miss' do
        challenge.guess('YYYYY')

        expect(challenge.hints).to eq([[:miss, :miss, :miss, :miss, :miss]])
      end
    end

    context 'when attempt has all found' do
      let(:target) { 'ABXYZ' }

      it 'flags all as found' do
        challenge.guess('XYZAB')

        expect(challenge.hints).to eq([[:found, :found, :found, :found, :found]])
      end
    end

    context 'when attempt has all hits' do
      let(:target) { 'XXXXX' }

      it 'flags all as hit' do
        challenge.guess('XXXXX')

        expect(challenge.hints).to eq([[:hit, :hit, :hit, :hit, :hit]])
      end
    end
  end

  describe '#started?' do
    context 'when attempts empty' do
      it 'returns false' do
        expect(challenge.started?).to eq false
      end
    end

    context 'when attempts present' do
      it 'returns true' do
        challenge.guess('start')

        expect(challenge.started?).to eq true
      end
    end
  end
end
