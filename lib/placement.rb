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
        if o.to_s == orientation
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

    def valid?
      @x.is_a? Integer and
      @y.is_a? Integer and
      !@orientation.nil?
    end

  end
end
