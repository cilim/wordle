module Wordle
  class Game
    extend Forwardable

    WORD_SIZE = 5
    def_delegators :challenge, :ended?, :outcome

    attr_reader :challenge

    def initialize(target = nil)
      target = Word.new(target || Dictionary.random_pick)
      raise 'Game works with 5-letter words only!' if target.size != WORD_SIZE
      raise 'Word not in dictionary!' unless valid_word?(target)

      @challenge = Challenge.new(target)
    end

    def guess(word)
      challenge.attempt(word)
    end

    def keyboard
      Keyboard.letter_rows.map do |row|
        row.map(&color_letter)
      end
    end

    def feedback
      return unless challenge.started?

      challenge.attempts.map do |attempt|
        attempt.hints.map.with_index do |hint, i|
          case hint
          when :hit then Terminal.white_on_green(attempt[i])
          when :found then Terminal.white_on_yellow(attempt[i])
          when :miss then Terminal.white_on_red(attempt[i])
          end
        end
      end
    end

    def valid_word?(word)
      Dictionary.include?(Word.new(word))
    end

    private

    def color_letter
      lambda do |letter|
        next Terminal.white_on_black(letter) unless challenge.used_letters.include?(letter)

        if challenge.hit_letters.include?(letter)
          Terminal.white_on_green(letter)
        elsif !challenge.target_contains?(letter)
          Terminal.white_on_red(letter)
        else
          Terminal.white_on_yellow(letter)
        end
      end
    end
  end
end
