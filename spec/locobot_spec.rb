require 'minitest/spec'
require 'minitest/autorun'
require 'debugger'

require './lib/placement'
require './lib/table'
require './lib/locobot'

include Locobot
include ORIENTATIONS
include STATUS

describe Locobot do

  before do
    @locobot = Robot.new
  end

  describe "when given an unrecognised command" do
    it "gives an error" do
      @locobot.execute('UNRECOGNISED').must_be_nil
      @locobot.error.must_equal UNRECOGNISED_COMMAND
    end
  end

  describe "when placed without a table" do
    it "tells me it needs a tabletop" do
      @locobot.execute('PLACE 0,0,NORTH').must_be_nil
      @locobot.error.must_equal NO_TABLE
    end
  end

  describe "when asked to report, move or turn before placing" do
    it "tells me it has not been placed" do
      @locobot.table = Table.new 5, 5
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

    it "doesn't allow positions out of range" do
      @locobot.table = Table.new 5, 5
      @locobot.execute('PLACE 0,6,NORTH').must_be_nil
      @locobot.execute('PLACE 6,0,NORTH').must_be_nil
    end

    it "has a position and orientation" do
      x, y, orientation = [0, 0, NORTH]
      @locobot.table = Table.new 5, 5
      @locobot.execute("PLACE #{x} #{y} NORTH").wont_be_nil
      @locobot.placement.x.must_equal x
      @locobot.placement.y.must_equal y
      @locobot.placement.orientation.must_equal orientation
    end

    it "can report it's position" do
      x, y, orientation = [2, 4, 'WEST']
      @locobot.table = Table.new 5, 5
      @locobot.execute("PLACE #{x} #{y} #{orientation}").wont_be_nil
      @locobot.execute('REPORT').must_equal "CURRENT POSITION: #{x},#{y}\nFACING: #{orientation}"
    end

    it "can move if possible" do
      @locobot.table = Table.new 5, 5
      @locobot.execute("PLACE 0,0,EAST").wont_be_nil
      @locobot.execute('MOVE').must_equal COMMAND_SUCCESSFUL
      @locobot.placement.must_equal Placement.new(1, 0, EAST)
      @locobot.execute("PLACE 0,0,WEST").wont_be_nil
      @locobot.execute('MOVE').must_be_nil
      @locobot.error.must_equal MOVEMENT_IMPOSSIBLE
    end

    it "can turn" do
      @locobot.table = Table.new 5, 5
      @locobot.execute("PLACE 0,0,NORTH").wont_be_nil

      @locobot.execute("RIGHT").wont_be_nil
      @locobot.placement.orientation.must_equal EAST
      @locobot.execute("RIGHT").wont_be_nil
      @locobot.placement.orientation.must_equal SOUTH
      @locobot.execute("RIGHT").wont_be_nil
      @locobot.placement.orientation.must_equal WEST
      @locobot.execute("RIGHT").wont_be_nil
      @locobot.placement.orientation.must_equal NORTH

      @locobot.execute("LEFT").wont_be_nil
      @locobot.placement.orientation.must_equal WEST
      @locobot.execute("LEFT").wont_be_nil
      @locobot.placement.orientation.must_equal SOUTH
      @locobot.execute("LEFT").wont_be_nil
      @locobot.placement.orientation.must_equal EAST
      @locobot.execute("LEFT").wont_be_nil
      @locobot.placement.orientation.must_equal NORTH
    end
  end

end
