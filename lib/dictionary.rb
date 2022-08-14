module Dictionary
  module_function

  WORDS = File.read(File.expand_path('dictionary.txt', __dir__)).split("\n").freeze

  def words
    WORDS
  end

  def random_pick
    WORDS.sample
  end

  def include?(word)
    raise 'expected to always receive upper cased word' if word.upcase != word

    WORDS.include?(word)
  end
end
