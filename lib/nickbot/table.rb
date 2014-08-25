# encoding: UTF-8

require './lib/nickbot/constants'
require './lib/nickbot/placement'
include Nickbot
include Nickbot::ORIENTATIONS

module Nickbot
  # Define a table with a width and height. Outputs an ASCII grid when cast as
  # a string. Can return Placements when asked for adjacent cells
  # @author Nick Butler
  # @attr [Integer] width number of cells wide
  # @attr [Integer] height number of cells high
  class Table
    attr_accessor :width, :height

    def initialize(width = 5, height = 5)
      @width = width.to_i
      @height = height.to_i

      throw 'Table dimensions must be greater than 0' unless volume > 0
    end

    # Output as grid with optional (Nickbot::Placement)
    # @param optional (Nickbot::Placement) coordinate and orientation
    # @return [String] ascii representation of table with optional marked cell
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

    def size
      "#{@width}x#{@height}"
    end

    def volume
      @width * @height
    end

    def coordinate_exists?(x, y)
      x < @width && y < @height
    end

    # Dynamic wrapper for directional commands below
    # @param [Nickbot::Placement] placement as starting point
    # @return [Nickbot::Placement, nil] new placement in direction of given
    #   placement if new placement is not out of the table's bounds,
    #   otherwise nil
    def cell_to(placement)
      send("#{placement.orientation.downcase}_of", placement.x, placement.y)
    end

    # The following methods accept x and y coordinates and return a Placement
    # or nil if out of bounds.
    # @param [Integer] x coordinate
    # @param [Integer] y coordinate
    # @return (see Nickbot::Table#cell_to)
    def north_of(x, y)
      Placement.new(x, y + 1, NORTH) unless y + 1 == @height
    end

    # @param (see Nickbot::Table#north_of)
    # @return (see Nickbot::Table#cell_to)
    def east_of(x, y)
      Placement.new(x + 1, y, EAST) unless x + 1 == @width
    end

    # @param (see Nickbot::Table#north_of)
    # @return (see Nickbot::Table#cell_to)
    def south_of(x, y)
      Placement.new(x, y - 1, SOUTH) unless y - 1 < 0
    end

    # @param (see Nickbot::Table#north_of)
    # @return (see Nickbot::Table#cell_to)
    def west_of(x, y)
      Placement.new(x - 1, y, WEST) unless x - 1 < 0
    end

    private

    # Methods to return parts of the ASCII grid
    # @private
    # @return [String] part of the ascii grid
    def top_border
      "\n" + '╔' + ('═══╤' * (width - 1)) + '═══╗' + "\n" +
             '║'
    end

    # @private
    # @return (see Nickbot::Table#top_border)
    def first_row
      str = ''
      (width - 1).times do |column|
        mark = (@x == column && @y == (height - 1)) ? @pointer : ' '
        str += " #{mark} │"
      end
      str
    end

    # @private
    # @return (see Nickbot::Table#top_border)
    def top_right_corner
      a_pointer = (@x == (width - 1) && @y == (height - 1)) ? @pointer :  ' '
      " #{a_pointer} ║" + "\n"
    end

    # @private
    # @return (see Nickbot::Table#top_border)
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

    # @private
    # @param [Integer] any given row to test against a given coordinate
    # @return (see Nickbot::Table#top_border)
    def additional_cells(row)
      str = ''
      (width - 1).times do |column|
        mark = (@x == column && @y == (height - row - 2)) ? @pointer : ' '
        str += " #{mark} │"
      end
      str
    end

    # @private
    # @param (see Nickbot::Table#additional_cells
    # @return (see Nickbot::Table#top_border)
    def bottom_right(row)
      pointer = @x == (width - 1) && @y == (height - row - 2) ? @pointer : ' '
      " #{pointer} ║" + "\n"
    end

    # @private
    # @return (see Nickbot::Table#top_border)
    def bottom_border
      '╚' + ('═══╧' * (width - 1)) + '═══╝' + "\n"
    end
  end
end
