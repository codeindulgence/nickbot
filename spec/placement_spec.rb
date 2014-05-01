require 'minitest/spec'
require 'minitest/autorun'

require './lib/placement'

# include Locobot

describe Placement do

  describe "when initialized with invalid values" do
    it "is invalid" do
      Placement.new('this', 'won\'t', 'work').valid?.must_equal false
    end
  end

  describe "when initialized with valid values" do
    it "is valid" do
      Placement.new('1', '1', 'NORTH').valid?.must_equal true
      Placement.new(1, 1, 'SOUTH').valid?.must_equal true
      Placement.new(0, 0, 'SOUTH').valid?.must_equal true
    end
  end

  describe "when asked to turn" do
    it "turns correctly" do
      placement = Placement.new(1, 1, NORTH)
      placement.turn_right.orientation.must_equal EAST
      placement.turn_right.orientation.must_equal SOUTH
      placement.turn_right.orientation.must_equal WEST
      placement.turn_right.orientation.must_equal NORTH

      placement.turn_left.orientation.must_equal WEST
      placement.turn_left.orientation.must_equal SOUTH
      placement.turn_left.orientation.must_equal EAST
      placement.turn_left.orientation.must_equal NORTH
    end
  end
end
