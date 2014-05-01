# encoding: UTF-8
require './lib/placement'

include Locobot
include ORIENTATIONS

class Table

  attr_accessor :width, :height

  # Parameters
  # width: Fixnum
  # height: Fixnum
  def initialize width, height
    @width = width
    @height = height
  end

  # Output as grid with optional Placement
  def to_s x = nil, y = nil
    # Top border and start of first row
    grid = "\n" + '╔' + ('═══╤'*(width-1)) + '═══╗' + "\n" +
                  '║'

    # First row
    # For each column over 1 add cell part and mark if necessary
    (self.width - 1).times do |column|
      mark = (x == column and y == (self.height - 1)) ? '◼' : ' '
      grid += " #{mark} │"
    end

    # Top right corner
    grid += " #{(x == (self.width - 1) and y == (self.height - 1)) ? '◼':' '} ║" + "\n"

    # Additional rows
    (self.height - 1).times do |row|
      grid +=     '╟' + ('───┼'*(width-1)) + '───╢' + "\n" +
                  '║'
      # Additional cells in these rows
      (self.width - 1).times do |column|
        mark = (x == column and y == (self.height - row - 2)) ? '◼' : ' '
        grid += " #{mark} │"
      end

      # Bottom right corner
      grid += " #{(x == (self.width - 1) and y == (self.height - row - 2)) ? '◼':' '} ║" + "\n"

    end

    # Bottom border
    grid += '╚' + ('═══╧'*(width-1)) + '═══╝' + "\n"

  end

  # No arguments
  # Returns String of format "<width>x<height>"
  def size
    "#{@width}x#{@height}"
  end

  # Returns true unless given coords are out of bounds
  def coordinate_exists? x, y
    x < @width and y < @height
  end

  # Expects Placement
  # Returns new placement or nil
  def cell_to placement
    send("#{placement.orientation.downcase}_of", placement.x, placement.y)
  end

  # Accepts x and y coordinates
  # Returns placement
  # or nil if out of bounds
  def north_of x, y
    Placement.new(x, y + 1, NORTH) unless y + 1 == @height
  end

  # Accepts x and y coordinates
  # Returns placement
  # or nil if out of bounds
  def east_of x, y
    Placement.new(x + 1, y, EAST) unless x + 1 == @width
  end

  # Accepts x and y coordinates
  # Returns placement
  # or nil if out of bounds
  def south_of x, y
    Placement.new(x, y - 1, SOUTH) unless y - 1 < 0
  end

  # Accepts x and y coordinates
  # Returns placement
  # or nil if out of bounds
  def west_of x, y
    Placement.new(x - 1, y, WEST) unless x - 1 < 0
  end
end
