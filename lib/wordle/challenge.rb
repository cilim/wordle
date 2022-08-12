module Wordle
  class Challenge
    MAX_ATTEMPTS = 6

    attr_reader :target, :attempts

    def initialize(target)
      @target = target
      @attempts = []
    end

    def guess(word)
      raise 'challenge has ended' if ended?

      attempts << word

      word == target
    end

    def ended?
      lost? || won?
    end

    def hints
      attempts.map do |attempt|
        tallied_characters = word_characters.tally

        attempt.chars.each.with_index do |char, index|
          next if tallied_characters[char].nil?

          tallied_characters[char] -= 1 if target.index(char) == index
        end

        word_characters.each.with_index.reduce([]) do |memo, (char, i)|
          memo << if attempt[i] == char
                    :hit
                  elsif tallied_characters.reject { |_, v| v.zero? }.include?(attempt[i])
                    tallied_characters[attempt[i]] -= 1
                    :found
                  else
                    :miss
                  end
        end
      end
    end

    def last_attempt
      attempts.last
    end

    def message
      return 'Challenge in progress' unless ended?

      won? ? "You won in #{attempts.size}! 🎉" : "You lost! Target was: #{target.upcase} 😓"
    end

    def started?
      !attempts.empty?
    end

    private

    def word_characters
      target.chars
    end

    def lost?
      !word_found? && attempts.size == MAX_ATTEMPTS
    end

    def won?
      word_found? && attempts.size <= MAX_ATTEMPTS
    end

    def word_found?
      attempts.include?(target)
    end

    attr_writer :attempts
  end
end
