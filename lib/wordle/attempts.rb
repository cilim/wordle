module Wordle
  class Attempts < Array
    attr_accessor :target
    alias last_attempt last

    def self.with_target(target)
      attempts = new
      attempts.target = target

      attempts
    end

    def <<(word)
      word = Word.new(word)
      word.target = target

      super(word)
    end

    def hints
      map(&:hints)
    end

    def used_letters
      flat_map(&:chars).uniq
    end
  end
end
