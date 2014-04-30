require 'minitest/spec'
require 'minitest/autorun'

require './lib/table'

describe Table do

  describe "when created" do
    it "has a size" do
      table = Table.new 5, 5
      assert_equal table.size, '5x5'
    end
  end

  describe "when asked about adjacent cells" do
    it "returns correct results" do
      table = Table.new 5, 5
      assert_equal [0, 1], table.north_of(0, 0)
      assert_equal nil, table.north_of(0, 4)

      assert_equal [1, 0], table.east_of(0, 0)
      assert_equal nil,  table.east_of(4, 0)

      assert_equal [4, 3], table.south_of(4, 4)
      assert_equal nil, table.south_of(0, 0)

      assert_equal [3, 0], table.west_of(4, 0)
      assert_equal nil,  table.west_of(0, 0)
    end
  end
end

