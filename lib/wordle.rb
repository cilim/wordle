class Wordle
  KEYBOARD = [
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm']
  ]

  def initialize
    @challenge = Challenge.new(dictionary.sample)
  end

  def attempt(word)
    return 'challenge has ended' if challenge.ended?
    return "#{word} not found in dictionary" unless dictionary.include?(word.downcase)

    challenge.guess(word.downcase)

    challenge_overview.tap do |overview|
      overview.concat("\n\n#{challenge.message}") if challenge.ended?
    end
  end

  def help
    used_letters = challenge.attempts.map(&:chars).flatten.uniq

    KEYBOARD.map do |row|
      row.map do |letter|
        if used_letters.include?(letter)
          pastel.white.on_black(letter)
        else
          pastel.black.on_white(letter)
        end
      end.join(' ')
    end.join("\n")
  end

  private

  attr_reader :challenge

  def dictionary
    File.read(File.expand_path('wordle/dictionary.txt', __dir__)).split("\n")
  end

  def challenge_overview
    challenge.status.map.with_index do |detail, i|
      character = challenge.last_attempt[i].upcase

      case detail
      when :hit then pastel.white.on_green.bold(character)
      when :found then pastel.white.on_yellow.bold(character)
      else pastel.white.on_red.bold(character)
      end
    end.join(' ')
  end

  def pastel
    Pastel.new
  end

  class Challenge
    MAX_ATTEMPTS = 6

    attr_reader :word, :attempts

    def initialize(word)
      @word = word
      @attempts = []
    end

    def guess(query)
      attempts << query

      query == word
    end

    def ended?
      lost? || won?
    end

    def status
      tallied_characters = word_characters.tally

      last_attempt.chars.each.with_index do |char, index|
        next if tallied_characters[char].nil?

        tallied_characters[char] -= 1 if word.index(char) == index
      end

      word_characters.each.with_index.reduce([]) do |memo, (char, i)|
        memo << if last_attempt[i] == char
                  :hit
                elsif tallied_characters.reject{|_, v| v.zero?}.include?(last_attempt[i])
                  tallied_characters[last_attempt[i]] -= 1
                  :found
                else
                  :miss
                end
      end
    end

    def last_attempt
      attempts.last
    end

    def message
      return 'Challenge in progress' unless ended?

      won? ? "YOU WON IN #{attempts.size} tries!" : 'YOU LOST!'
    end

    private

    def word_characters
      word.chars
    end

    def lost?
      !word_found? && attempts.size == MAX_ATTEMPTS
    end

    def won?
      word_found? && attempts.size <= MAX_ATTEMPTS
    end

    def word_found?
      attempts.include?(word)
    end

    attr_writer :attempts
  end
end
