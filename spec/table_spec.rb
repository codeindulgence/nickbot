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
      assert_equal table.north_of(0, 0), [0, 1]
      assert_equal table.north_of(0, 4), nil

      assert_equal table.east_of(0, 0), [1, 0]
      assert_equal table.east_of(4, 0), nil

      assert_equal table.south_of(4, 4), [4, 3]
      assert_equal table.south_of(0, 0), nil

      assert_equal table.west_of(4, 0), [3, 0]
      assert_equal table.west_of(0, 0), nil
    end
  end
end

