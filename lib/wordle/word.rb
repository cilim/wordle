module Wordle
  class Word < String
    attr_accessor :target

    def initialize(word)
      super(word).upcase!
    end

    def hints
      tallied_target_letters = target.chars.tally
      tallied_target_letters = subtract_hits(tallied_target_letters)

      map_hints(tallied_target_letters)
    end

    private

    def subtract_hits(tallied_target_letters)
      chars.each.with_index do |letter, index|
        next if tallied_target_letters[letter].nil?

        target_indexes_for_letter = target.chars.filter_map.with_index do |target_letter, i|
          i if target_letter == letter
        end

        tallied_target_letters[letter] -= 1 if target_indexes_for_letter.include?(index)
      end

      tallied_target_letters
    end

    def map_hints(tallied_target_letters)
      target.chars.map.with_index do |target_letter, i|
        if self[i] == target_letter
          :hit
        elsif tallied_target_letters.reject { |_, v| v.zero? }.include?(self[i])
          tallied_target_letters[self[i]] -= 1
          :found
        else
          :miss
        end
      end
    end
  end
end
