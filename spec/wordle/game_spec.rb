RSpec.describe Wordle::Game do
  let(:target) { 'crane' }

  describe 'new game' do
    context 'when target set to 4 letter word' do
      it 'raises RuntimeError' do
        expect { described_class.new('nope') }.to raise_error(RuntimeError)
      end
    end

    context 'when target set to 6 letter word' do
      it 'raises RuntimeError' do
        expect { described_class.new('toobig') }.to raise_error(RuntimeError)
      end
    end

    context 'when target set to 5 letter unknown word' do
      it 'raises RuntimeError' do
        expect { described_class.new('reckd') }.to raise_error(RuntimeError)
      end
    end

    context 'when target set to 5 letter word from dictionary' do
      it 'instantiates game object' do
        expect(described_class.new('crane')).to be_a(described_class)
      end

      describe '#challenge' do
        it 'returns challenge object' do
          expect(described_class.new('crane').challenge).to be_a(Wordle::Challenge)
        end

        it 'challenge target is a Wordle::Word' do
          expect(described_class.new('crane').challenge.target).to be_a(Wordle::Word)
        end
      end
    end
  end

  describe 'attempting to solve challenge' do
    context 'when word matches target' do
      it 'returns true' do
        game = described_class.new(target)

        expect(game.guess(target)).to eq true
      end
    end

    context 'when attempts fail' do
      it 'can fail 6 times and the 7th will raise an error' do
        game = described_class.new(target)
        wrong = 'pious'

        6.times do
          expect(game.guess(wrong)).to eq false
        end

        expect { game.guess(wrong) }.to raise_error(RuntimeError)
      end
    end
  end

  describe 'word validity in atttempts' do
    let(:game) { described_class.new(target) }

    context 'when word in dictionary' do
      it 'returns true' do
        expect(game.valid_word?('smoke')).to be_truthy
      end
    end

    context 'when word not in dictionary' do
      it 'returns false' do
        expect(game.valid_word?('yeets')).to be_falsey
      end
    end
  end

  describe '#keyboard' do
    let(:game) { described_class.new(target) }
    let(:keyboard) do
      [
        ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
        ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
        ['Z', 'X', 'C', 'V', 'B', 'N', 'M']
      ]
    end

    context 'when no attempts' do
      it 'returns keyboard layout with white on black keys' do
        expected_keyboard = keyboard.map { |row| row.map { |letter| white_on_black(letter) } }

        expect(game.keyboard).to eq(expected_keyboard)
      end
    end

    context 'with some attempts' do
      let(:word) { 'QUART' }

      it 'returns keyboard layout with black on white keys' do
        expected_keyboard = keyboard.map do |row|
          row.map do |letter|
            next white_on_black(letter) unless word.include?(letter)
            next white_on_green(letter) if target.upcase.index(letter) == word.index(letter)
            next white_on_yellow(letter) if target.upcase.chars.include?(letter)

            white_on_red(letter)
          end
        end

        game.guess(word)
        expect(game.keyboard).to eq(expected_keyboard)
      end
    end
  end

  describe '#feedback' do
    let(:game) { described_class.new(target) }

    context 'when no attempts made' do
      it 'is nil' do
        expect(game.feedback).to be_nil
      end
    end

    context 'when attempts made' do
      it 'returns white letters on green (hits), yellow (found) and red (missed)' do
        word = 'cargo'
        expected_keyboard = word.chars.map.with_index do |char, i|
          next white_on_green(char.upcase) if char == target[i]
          next white_on_yellow(char.upcase) if target.include?(char) && char != target[i]

          white_on_red(char.upcase)
        end

        game.guess(word)

        expect(game.feedback).to eq([expected_keyboard])
      end
    end
  end

  describe '#outcome' do
    let(:game) { described_class.new(target) }

    context 'when no attempts' do
      it 'returns challenge in progress' do
        expect(game.outcome).to eq('Challenge in progress')
      end
    end

    context 'when some attempts done' do
      it 'returns challenge in progress' do
        game.guess('pious')
        game.guess('smoke')

        expect(game.outcome).to eq('Challenge in progress')
      end
    end

    context 'when all 6 attempts fail' do
      it 'returns you lost message' do
        6.times { game.guess('wrong') }

        expect(game.outcome).to eq('You lost! Target was: CRANE 😓')
      end
    end

    context 'when target found' do
      it 'returns you win message' do
        game.guess(target)

        expect(game.outcome).to eq('You won in 1! 🎉')
      end
    end
  end

  describe '#ended?' do
    it 'delegates method to challenge' do
      game = described_class.new

      expect(game).not_to be_ended
    end
  end

  def black_on_white(letter)
    "\e[30;47m#{letter}\e[0m"
  end

  def white_on_black(letter)
    "\e[37;40m#{letter}\e[0m"
  end

  def white_on_green(letter)
    "\e[37;42;1m#{letter}\e[0m"
  end

  def white_on_red(letter)
    "\e[37;41;1m#{letter}\e[0m"
  end

  def white_on_yellow(letter)
    "\e[37;43;1m#{letter}\e[0m"
  end
end
