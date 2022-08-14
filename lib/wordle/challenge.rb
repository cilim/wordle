module Wordle
  class Challenge
    extend Forwardable

    MAX_ATTEMPTS = 6
    def_delegators :attempts, :hints, :last_attempt, :used_letters

    attr_reader :target, :attempts

    def initialize(target)
      @target = Word.new(target)
      @attempts = Attempts.with_target(@target)
    end

    def attempt(word)
      raise 'challenge has ended' if ended?

      attempts << word

      last_attempt == target
    end

    def ended?
      lost? || won?
    end

    def outcome
      return 'Challenge in progress' unless ended?

      won? ? "You won in #{attempts.size}! 🎉" : "You lost! Target was: #{target} 😓"
    end

    def started?
      !attempts.empty?
    end

    def hit_letters
      attempts.flat_map do |attempt|
        attempt.chars.filter_map.with_index { |char, i| char if char == target[i] }
      end.uniq
    end

    def target_contains?(letter)
      raise 'unexpected downcased letter received' if letter.upcase != letter

      target.chars.include?(letter)
    end

    private

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
