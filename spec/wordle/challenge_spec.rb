RSpec.describe Wordle::Challenge do
  let(:target) { 'SMOKE' }
  let(:challenge) { described_class.new(target) }

  describe '#target' do
    it 'returns target value' do
      expect(challenge.target).to eq(target)
    end

    it 'target is a Wordle::Word' do
      expect(challenge.target).to be_a(Wordle::Word)
    end
  end

  describe '#attempts' do
    it 'returns an instance of attempts' do
      expect(challenge.attempts).to be_a(Wordle::Attempts)
    end

    context 'when no attempts made' do
      it 'returns attempts' do
        expect(challenge.attempts).to eq([])
      end
    end

    context 'when attempts present' do
      it 'returns attempts' do
        challenge.attempt('loose')
        challenge.attempt('smote')

        expect(challenge.attempts).to eq(['LOOSE', 'SMOTE'])
      end
    end
  end

  describe '#guess' do
    it 'adds attempt to attempts' do
      expect { challenge.attempt('loose') }.to change(challenge, :attempts).from([]).to(['LOOSE'])
    end

    context 'when word is same as target' do
      it 'returns true' do
        expect(challenge.attempt(target)).to be_truthy
      end
    end

    context 'when word is different than target' do
      it 'returns false' do
        expect(challenge.attempt('smote')).to be_falsey
      end
    end

    context 'when attempts maxed out' do
      it 'returns false' do
        6.times { challenge.attempt('loose') }

        expect { challenge.attempt(target) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#ended?' do
    context 'when attempts less than max attempts and target found' do
      it 'returns true' do
        challenge.attempt(target)

        expect(challenge.ended?).to eq true
      end
    end

    context 'when attempts less than max attempts and target not found' do
      it 'returns false' do
        challenge.attempt('smote')

        expect(challenge.ended?).to eq false
      end
    end

    context 'when attempts same as max attempts and target found' do
      it 'returns true' do
        5.times { challenge.attempt('loose') }

        challenge.attempt(target)

        expect(challenge.ended?).to eq true
      end
    end

    context 'when attempts same as max attempts and target not found' do
      it 'returns true' do
        6.times { challenge.attempt('loose') }

        expect(challenge.ended?).to eq true
      end
    end
  end

  describe '#last_attempt' do
    it 'returns last attempt' do
      challenge.attempt('pious')
      challenge.attempt(target)

      expect(challenge.last_attempt).to eq(target)
    end
  end

  describe '#used_letters' do
    it 'returns unique used letters' do
      challenge.attempt('smote')
      challenge.attempt(target)

      expect(challenge.used_letters).to eq(['S', 'M', 'O', 'T', 'E', 'K'])
    end
  end

  describe '#outcome' do
    context 'when challenge in progress' do
      it 'returns Challenge in progress' do
        challenge.attempt('pious')

        expect(challenge.outcome).to eq('Challenge in progress')
      end
    end

    context 'when challenge ended' do
      it 'returns Won if attempts include target' do
        challenge.attempt(target)

        expect(challenge.outcome).to eq('You won in 1! 🎉')
      end

      it 'returns Lost if attempts without target' do
        6.times { challenge.attempt('loose') }

        expect(challenge.outcome).to eq('You lost! Target was: SMOKE 😓')
      end
    end
  end

  describe '#hints' do
    let(:target) { 'XXXXX' }

    it 'returns hints for all attempts' do
      challenge.attempt('XXXXY')
      challenge.attempt('YYYYX')

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
        challenge.attempt('loose')

        expect(challenge.hints).to eq([[:miss, :miss, :hit, :found, :hit]])
      end
    end

    context 'when attempt has duplicate letters, both only found, and target has 2 same letters' do
      let(:target) { 'oopsy' }

      it 'flags first duplicate letter as found and second as found' do
        challenge.attempt('stood')

        expect(challenge.hints).to eq([[:found, :miss, :found, :found, :miss]])
      end
    end

    context 'when attempt has all misses' do
      let(:target) { 'XXXXX' }

      it 'flags all as miss' do
        challenge.attempt('YYYYY')

        expect(challenge.hints).to eq([[:miss, :miss, :miss, :miss, :miss]])
      end
    end

    context 'when attempt has all found' do
      let(:target) { 'ABXYZ' }

      it 'flags all as found' do
        challenge.attempt('XYZAB')

        expect(challenge.hints).to eq([[:found, :found, :found, :found, :found]])
      end
    end

    context 'when attempt has all hits' do
      let(:target) { 'XXXXX' }

      it 'flags all as hit' do
        challenge.attempt('XXXXX')

        expect(challenge.hints).to eq([[:hit, :hit, :hit, :hit, :hit]])
      end
    end
  end

  describe '#started?' do
    context 'when attempts empty' do
      it 'returns false' do
        expect(challenge.started?).to eq(false)
      end
    end

    context 'when attempts present' do
      it 'returns true' do
        challenge.attempt('start')

        expect(challenge.started?).to eq(true)
      end
    end
  end

  describe '#hit_letters' do
    context 'when attempts empty' do
      it 'returns empty array' do
        expect(challenge.hit_letters).to eq([])
      end
    end

    context 'when attempts present but no hits' do
      it 'returns empty array' do
        challenge.attempt('right')

        expect(challenge.hit_letters).to eq([])
      end
    end

    context 'when 1 attempt present with some hits' do
      it 'returns array of letters on correct index of target' do
        challenge.attempt('slope')

        expect(challenge.hit_letters).to eq(['S', 'O', 'E'])
      end
    end

    context 'when multiple attempts present with some hits' do
      it 'returns empty array' do
        challenge.attempt('slope')
        challenge.attempt('husks')
        challenge.attempt('smith')

        expect(challenge.hit_letters).to eq(['S', 'O', 'E', 'K', 'M'])
      end
    end
  end

  describe '#target_contains?' do
    context 'when letter is downcased' do
      it 'raises error' do
        expect { challenge.target_contains?('k') }.to raise_error(RuntimeError)
      end
    end

    context 'when letter is upcased' do
      it 'returns if letter is in target' do
        expect(challenge.target_contains?('K')).to eq(true)
      end
    end
  end
end
