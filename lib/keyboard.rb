module Keyboard
  module_function

  LETTERS = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M']
  ].freeze

  def self.letter_rows
    [upper_row, middle_row, bottom_row]
  end

  def upper_row
    LETTERS[0]
  end

  def middle_row
    LETTERS[1]
  end

  def bottom_row
    LETTERS[2]
  end
end
