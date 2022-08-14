module Terminal
  module_function

  COLOR_WHEEL = Pastel.new

  def put(body, new_line: true)
    new_line ? puts(body) : print(body)
  end

  def get
    gets.chomp
  end

  def clear
    system('clear'); # rubocop:disable
  end

  def white_on_green(value)
    COLOR_WHEEL.white.on_green.bold(value)
  end

  def white_on_yellow(value)
    COLOR_WHEEL.white.on_yellow.bold(value)
  end

  def white_on_red(value)
    COLOR_WHEEL.white.on_red.bold(value)
  end

  def white_on_black(value)
    COLOR_WHEEL.white.on_black(value)
  end
end
