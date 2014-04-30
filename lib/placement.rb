require 'debugger'
module Locobot

  module ORIENTATIONS
    NORTH = :N
    EAST  = :E
    SOUTH = :S
    WEST  = :W
  end

  class Placement

    attr_accessor :x, :y, :orientation

    def initialize x, y, orientation
      # debugger
      @x = x.to_i if x.to_s =~ /\d+/
      @y = y.to_i if y.to_s =~ /\d+/
      ORIENTATIONS.constants.each do |o|
        if o.to_s == orientation
          @orientation = ORIENTATIONS.const_get o
        end
      end
    end

    def valid?
      @x.is_a? Integer and
      @y.is_a? Integer and
      !@orientation.nil?
    end

  end
end
