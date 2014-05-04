# encoding: UTF-8

require './lib/locobot/constants'
include Locobot
include Locobot::ORIENTATIONS

module Locobot
  # Container for a co-ordinate and orientation. Includes turn methods to
  # modify the orientation
  class Placement
    attr_accessor :x, :y, :orientation

    def initialize(x, y, orientation)
      @x = x.to_i if x.to_s =~ /\d+/
      @y = y.to_i if y.to_s =~ /\d+/
      ORIENTATIONS.constants.each do |o|
        @orientation = o if o.to_s == orientation.to_s
      end
    end

    def to_s
      <<-EOS.chomp.gsub(/^\s+/, '')
        CURRENT POSITION: #{x},#{y}
        FACING: #{orientation}
      EOS
    end

    def ==(other)
      to_s == other.to_s
    end

    def valid?
      @x.is_a?(Integer) &&
      @y.is_a?(Integer) &&
      orientation_set?
    end

    def orientation_set?
      !@orientation.nil?
    end

    def pointer
      case orientation
      when NORTH then '▲'
      when EAST  then '▶'
      when SOUTH then '▼'
      when WEST  then '◀'
      end
    end

    def turn_right
      new_index = ORIENTATIONS.constants.index(orientation) + 1
      self.orientation = (ORIENTATIONS.constants[new_index] || NORTH)
      self
    end

    def turn_left
      new_index = ORIENTATIONS.constants.index(orientation) - 1
      self.orientation = ORIENTATIONS.constants[new_index]
      self
    end
  end
end
