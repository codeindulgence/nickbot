# encoding: UTF-8

require './lib/locobot/constants'
require './lib/locobot/placement'
include Locobot
include Locobot::ORIENTATIONS

module Locobot
  # Define a table with a width and height. Outputs an ASCII grid when cast as
  # a string. Can return Placements when asked for adjacent cells
  class Table
    attr_accessor :width, :height

    # Parameters
    # width: Fixnum
    # height: Fixnum
    def initialize(width, height)
      @width = width
      @height = height
    end

    # Output as grid with optional Placement
    def to_s(placement = nil)
      if placement.is_a? Placement
        @x = placement.x
        @y = placement.y
        @pointer = placement.pointer
      end

      top_border +
      first_row +
      top_right_corner +
      additional_rows +
      bottom_border
    end

    # No arguments
    # Returns String of format "<width>x<height>"
    def size
      "#{@width}x#{@height}"
    end

    # Returns true unless given coords are out of bounds
    def coordinate_exists?(x, y)
      x < @width && y < @height
    end

    # Expects Placement
    # Returns new placement or nil
    def cell_to(placement)
      send("#{placement.orientation.downcase}_of", placement.x, placement.y)
    end

    # The following methods accept x and y coordinates and return a Placement
    # or nil if out of bounds.
    def north_of(x, y)
      Placement.new(x, y + 1, NORTH) unless y + 1 == @height
    end

    def east_of(x, y)
      Placement.new(x + 1, y, EAST) unless x + 1 == @width
    end

    def south_of(x, y)
      Placement.new(x, y - 1, SOUTH) unless y - 1 < 0
    end

    def west_of(x, y)
      Placement.new(x - 1, y, WEST) unless x - 1 < 0
    end

    private

    # Methods to return parts of the ASCII grid

    def top_border
      "\n" + '╔' + ('═══╤' * (width - 1)) + '═══╗' + "\n" +
             '║'
    end

    def first_row
      str = ''
      (width - 1).times do |column|
        mark = (@x == column && @y == (height - 1)) ? @pointer : ' '
        str += " #{mark} │"
      end
      str
    end

    def top_right_corner
      a_pointer = (@x == (width - 1) && @y == (height - 1)) ? @pointer :  ' '
      " #{a_pointer} ║" + "\n"
    end

    def additional_rows
      str = ''
      (height - 1).times do |row|
        str +=     '╟' + ('───┼' * (width - 1)) + '───╢' + "\n" +
                   '║'
        str += additional_cells row
        str += bottom_right row
      end
      str
    end

    def additional_cells(row)
      str = ''
      (width - 1).times do |column|
        mark = (@x == column && @y == (height - row - 2)) ? @pointer : ' '
        str += " #{mark} │"
      end
      str
    end

    def bottom_right(row)
      pointer = @x == (width - 1) && @y == (height - row - 2) ? @pointer : ' '
      " #{pointer} ║" + "\n"
    end

    def bottom_border
      '╚' + ('═══╧' * (width - 1)) + '═══╝' + "\n"
    end
  end
end
