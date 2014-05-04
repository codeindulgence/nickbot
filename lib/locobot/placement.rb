# encoding: UTF-8

require './lib/locobot/constants'
include Locobot
include Locobot::ORIENTATIONS

module Locobot
  # Container for a co-ordinate and orientation. Includes turn methods to
  # modify the orientation
  # @author Nick Butler
  # @attr [Integer] x number off cells wide
  # @attr [Integer] y number off cells high
  # @attr [String] orientation from (Locobot::ORIENTATIONS)
  class Placement
    attr_accessor :x, :y, :orientation

    def initialize(x, y, orientation)
      @x = x.to_i if x.to_s =~ /\d+/
      @y = y.to_i if y.to_s =~ /\d+/
      ORIENTATIONS.constants.each do |o|
        @orientation = o if o.to_s == orientation.to_s
      end
    end

    # @return [String] representing placement as string in format:
    #   CURRENT POSITION: X, Y
    #   FACING: ORIENTATION
    def to_s
      <<-EOS.chomp.gsub(/^\s+/, '')
        CURRENT POSITION: #{x},#{y}
        FACING: #{orientation}
      EOS
    end

    # Test equality of placements by using string method
    # @param [Placement, Object] should be another placement
    # @return [Boolean] if matching
    def ==(other)
      to_s == other.to_s
    end

    # Test if given attributes are valid
    # @return [Boolean] true if coordinates are numbers and orintation is one
    #   of (Locobot::ORIENTATIONS)
    def valid?
      @x.is_a?(Integer) &&
      @y.is_a?(Integer) &&
      orientation_set?
    end

    def orientation_set?
      !@orientation.nil?
    end

    # @return [String] of arrow character representing given orientation
    def pointer
      case orientation
      when NORTH then '▲'
      when EAST  then '▶'
      when SOUTH then '▼'
      when WEST  then '◀'
      end
    end

    # @return [Locobot::Placement] after modifying orientation
    def turn_right
      new_index = ORIENTATIONS.constants.index(orientation) + 1
      self.orientation = (ORIENTATIONS.constants[new_index] || NORTH)
      self
    end

    # (Locobot::Placement#turn_right)
    def turn_left
      new_index = ORIENTATIONS.constants.index(orientation) - 1
      self.orientation = ORIENTATIONS.constants[new_index]
      self
    end
  end
end
