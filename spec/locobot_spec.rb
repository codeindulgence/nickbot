require 'minitest/spec'
require 'minitest/autorun'

require './lib/locobot'

include Locobot
include ORIENTATIONS
include STATUS

describe Locobot do

  before do
    @locobot = Robot.new
  end

  describe "when placed without a table" do
    it "tells me it needs a tabletop" do
      @locobot.execute('PLACE', 0, 0, NORTH).must_be_nil
      @locobot.error.must_equal NO_TABLE
    end
  end

  describe "when asked to report, move or turn before placing" do
    it "tells me it has not been placed" do
      @locobot.execute('MOVE').must_be_nil
      @locobot.error.must_equal NOT_PLACED

      @locobot.execute('LEFT').must_be_nil
      @locobot.error.must_equal NOT_PLACED

      @locobot.execute('RIGHT').must_be_nil
      @locobot.error.must_equal NOT_PLACED

      @locobot.execute('REPORT').must_be_nil
      @locobot.error.must_equal NOT_PLACED
    end
  end

  describe "when placed on a table" do
    it "has a position and orientation" do
      x, y, orientation = [0, 0, NORTH]
      @locobot.table = Table.new 5, 5
      @locobot.execute('PLACE', x, y, orientation)
      @locobot.x.must_equal x
      @locobot.y.must_equal y
      @locobot.orientation.must_equal orientation
    end
  end

end
