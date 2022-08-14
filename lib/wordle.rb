module Wordle
  module_function

  def play(target = nil)
    game = Game.new(target)

    Terminal.clear
    Terminal.put("\n#{keyboard_feedback(game)}\n\n")
    Terminal.put('Enter 5 letter word: ', new_line: false)

    solve(game)

    puts game.outcome
  end

  def solve(game)
    until game.ended?
      word = Word.new(Terminal.get)
      next Terminal.put(game.challenge.target) if word == '--HELP'
      next Terminal.put("#{word} not found in dictionary. Retry: ", new_line: false) unless game.valid_word?(word)

      game.guess(word)
      Terminal.clear
      Terminal.put("\n#{keyboard_feedback(game)}")
      Terminal.put("\n#{challenge_feedback(game)}")
      Terminal.put("\nTry again: ", new_line: false) unless game.ended?
    end
  end

  def keyboard_feedback(game)
    game.keyboard.map { |row| row.join(' ') }.join("\n")
  end

  def challenge_feedback(game)
    game.feedback.map { |row| row.join(' ') }.join("\n")
  end
end
