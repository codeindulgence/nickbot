require 'minitest/spec'
require 'minitest/autorun'

require './lib/table'

describe Table do

  describe "when created" do
    it "has a size" do
      table = Table.new 5, 5
      table.size.must_equal '5x5'
    end
  end

  describe "when asked about a given cell" do
    it "tells me if that cell exists" do
      table = Table.new 5, 5
      table.coordinate_exists?(0, 0).must_equal true
      table.coordinate_exists?(2, 3).must_equal true
      table.coordinate_exists?(0, 6).must_equal false
      table.coordinate_exists?(6, 0).must_equal false
    end
  end

  describe "when asked about adjacent cells" do
    it "returns correct results" do
      table = Table.new 5, 5
      table.north_of(0, 0).must_equal [0, 1]
      table.north_of(0, 4).must_be_nil

      table.east_of(0, 0).must_equal [1, 0]
      table.east_of(4, 0).must_be_nil

      table.south_of(4, 4).must_equal [4, 3]
      table.south_of(0, 0).must_be_nil

      table.west_of(4, 0).must_equal [3, 0]
      table.west_of(0, 0).must_be_nil
    end
  end
end
