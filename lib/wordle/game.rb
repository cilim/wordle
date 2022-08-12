module Wordle
  class Game
    extend Forwardable

    def_delegators :challenge, :ended?

    KEYBOARD = [
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['z', 'x', 'c', 'v', 'b', 'n', 'm']
    ].freeze
    DICTIONARY = File.read(File.expand_path('dictionary.txt', __dir__)).split("\n").freeze
    PRINT = Pastel.new
    WORD_SIZE = 5

    def initialize(target = nil)
      target ||= DICTIONARY.sample
      raise 'Game works with 5-letter words only!' if target.size != WORD_SIZE
      raise 'Word not in dictionary!' unless valid_word?(target)

      @challenge = Challenge.new(target)
    end

    def attempt(word)
      challenge.guess(word.downcase)
    end

    def help
      used_letters = challenge.attempts.map(&:chars).flatten.uniq

      KEYBOARD.map do |row|
        row.map do |letter|
          if used_letters.include?(letter)
            PRINT.black.on_white(letter.upcase)
          else
            PRINT.white.on_black(letter.upcase)
          end
        end
      end
    end

    def feedback
      return unless challenge.started?

      challenge.hints.map.with_index do |hint, i|
        attempt = challenge.attempts[i].upcase

        attempt.chars.map.with_index do |character, j|
          case hint[j]
          when :hit then PRINT.white.on_green.bold(character)
          when :found then PRINT.white.on_yellow.bold(character)
          when :miss then PRINT.white.on_red.bold(character)
          else raise "unknown hint :#{hint}"
          end
        end
      end
    end

    def outcome
      challenge.message
    end

    def valid_word?(word)
      DICTIONARY.include?(word)
    end

    private

    attr_reader :challenge
  end
end
