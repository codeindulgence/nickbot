require 'debugger'
module Locobot

  module ORIENTATIONS
    NORTH = :NORTH
    EAST  = :EAST
    SOUTH = :SOUTH
    WEST  = :WEST
  end

  class Placement

    attr_accessor :x, :y, :orientation

    def initialize x, y, orientation
      @x = x.to_i if x.to_s =~ /\d+/
      @y = y.to_i if y.to_s =~ /\d+/
      ORIENTATIONS.constants.each do |o|
        if o.to_s == orientation.to_s
          @orientation = o
        end
      end
    end

    def to_s
      <<-EOS.chomp.gsub(/^\s+/, '')
        CURRENT POSITION: #{x},#{y}
        FACING: #{orientation}
      EOS
    end

    def == object
      self.to_s == object.to_s
    end

    def valid?
      @x.is_a? Integer and
      @y.is_a? Integer and
      !@orientation.nil?
    end

    def turn_right
      new_index = ORIENTATIONS.constants.index(self.orientation) + 1
      self.orientation = (ORIENTATIONS.constants[new_index] or NORTH)
      self
    end

    def turn_left
      new_index = ORIENTATIONS.constants.index(self.orientation) - 1
      self.orientation = ORIENTATIONS.constants[new_index]
      self
    end

  end
end
