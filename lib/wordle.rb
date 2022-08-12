module Wordle
  module_function

  def play(target = nil)
    game = Game.new(target)

    clear_screen
    puts "\n#{print_help(game)}\n\n"
    print 'Enter 5 letter word: '

    solve(game)

    puts game.outcome
  end

  def solve(game)
    until game.ended?
      word = gets.chomp.downcase
      next print("#{word} not found in dictionary. Retry: ") unless game.valid_word?(word)

      game.attempt(word)
      clear_screen
      puts "\n#{print_help(game)}"
      puts "\n#{print_feedback(game)}"
      print "\nTry again: " unless game.ended?
    end
  end

  def print_help(game)
    game.help.map { |row| row.join(' ') }.join("\n")
  end

  def print_feedback(game)
    game.feedback.map { |row| row.join(' ') }.join("\n")
  end

  def clear_screen
    system('clear'); # rubocop:disable
  end
end
