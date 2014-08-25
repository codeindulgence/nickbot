# encoding: UTF-8

require 'minitest/spec'
require 'minitest/autorun'

require './lib/nickbot/robot'
require './lib/nickbot/placement'
require './lib/nickbot/table'

describe Robot do

  before do
    @nickbot = Robot.new
  end

  describe 'when given an unrecognised command' do
    it 'returns nil and sets status' do
      @nickbot.execute('UNRECOGNISED').must_be_nil
      @nickbot.status.must_equal UNRECOGNISED_COMMAND
      @nickbot.table = Table.new 5, 5
      @nickbot.execute('MOVE 1').must_be_nil
      @nickbot.status.must_equal INVALID_COMMAND_FORMAT
      @nickbot.execute('PLACE 1 1 NORTH x').must_be_nil
      @nickbot.status.must_equal INVALID_COMMAND_FORMAT
    end
  end

  describe 'when placed without a table' do
    it 'tells me it needs a tabletop' do
      @nickbot.execute('PLACE 0,0,NORTH').must_be_nil
      @nickbot.status.must_equal NO_TABLE
    end
  end

  describe 'when asked to report, move or turn before placing' do
    it 'tells me it has not been placed' do
      @nickbot.table = Table.new 5, 5
      @nickbot.execute('MOVE').must_be_nil
      @nickbot.status.must_equal NOT_PLACED

      @nickbot.execute('LEFT').must_be_nil
      @nickbot.status.must_equal NOT_PLACED

      @nickbot.execute('RIGHT').must_be_nil
      @nickbot.status.must_equal NOT_PLACED

      @nickbot.execute('REPORT').must_be_nil
      @nickbot.status.must_equal NOT_PLACED
    end
  end

  describe 'when placed on a table' do

    it "doesn't allow positions out of range" do
      @nickbot.table = Table.new 5, 5
      @nickbot.execute('PLACE 0,6,NORTH').must_be_nil
      @nickbot.execute('PLACE 6,0,NORTH').must_be_nil
    end

    it 'has a position and orientation' do
      x, y, orientation = [0, 0, NORTH]
      @nickbot.table = Table.new 5, 5
      @nickbot.execute("PLACE #{x} #{y} NORTH").wont_be_nil
      @nickbot.placement.x.must_equal x
      @nickbot.placement.y.must_equal y
      @nickbot.placement.orientation.must_equal orientation
    end

    it "can report it's position" do
      x, y, orientation = [2, 4, 'WEST']
      @nickbot.table = Table.new 5, 5
      @nickbot.execute("PLACE #{x} #{y} #{orientation}").wont_be_nil
      table = %Q(
╔═══╤═══╤═══╤═══╤═══╗
║   │   │ ◀ │   │   ║
╟───┼───┼───┼───┼───╢
║   │   │   │   │   ║
╟───┼───┼───┼───┼───╢
║   │   │   │   │   ║
╟───┼───┼───┼───┼───╢
║   │   │   │   │   ║
╟───┼───┼───┼───┼───╢
║   │   │   │   │   ║
╚═══╧═══╧═══╧═══╧═══╝
)
      @nickbot.execute('REPORT').must_equal(
        table + "CURRENT POSITION: #{x},#{y}\nFACING: #{orientation}"
      )
    end

    it 'can move if possible' do
      @nickbot.table = Table.new 5, 5
      @nickbot.execute('PLACE 0,0,EAST').wont_be_nil
      @nickbot.execute('MOVE').must_equal COMMAND_SUCCESSFUL
      @nickbot.placement.must_equal Placement.new(1, 0, EAST)
      @nickbot.execute('PLACE 0,0,WEST').wont_be_nil
      @nickbot.execute('MOVE').must_be_nil
      @nickbot.status.must_equal MOVEMENT_IMPOSSIBLE
    end

    it 'can turn' do
      @nickbot.table = Table.new 5, 5
      @nickbot.execute('PLACE 0,0,NORTH').wont_be_nil

      @nickbot.execute('RIGHT').wont_be_nil
      @nickbot.placement.orientation.must_equal EAST
      @nickbot.execute('RIGHT').wont_be_nil
      @nickbot.placement.orientation.must_equal SOUTH
      @nickbot.execute('RIGHT').wont_be_nil
      @nickbot.placement.orientation.must_equal WEST
      @nickbot.execute('RIGHT').wont_be_nil
      @nickbot.placement.orientation.must_equal NORTH

      @nickbot.execute('LEFT').wont_be_nil
      @nickbot.placement.orientation.must_equal WEST
      @nickbot.execute('LEFT').wont_be_nil
      @nickbot.placement.orientation.must_equal SOUTH
      @nickbot.execute('LEFT').wont_be_nil
      @nickbot.placement.orientation.must_equal EAST
      @nickbot.execute('LEFT').wont_be_nil
      @nickbot.placement.orientation.must_equal NORTH
    end
  end

end
