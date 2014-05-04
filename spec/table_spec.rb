# encoding: UTF-8
require 'minitest/spec'
require 'minitest/autorun'
require './lib/locobot/table'

describe Table do

  describe 'when created' do
    it 'has a size' do
      table = Table.new 5, 5
      table.size.must_equal '5x5'
    end
  end

  describe 'when asked about a given cell' do
    it 'tells me if that cell exists' do
      table = Table.new 5, 5
      table.coordinate_exists?(0, 0).must_equal true
      table.coordinate_exists?(2, 3).must_equal true
      table.coordinate_exists?(0, 6).must_equal false
      table.coordinate_exists?(6, 0).must_equal false
    end
  end

  describe 'when asked about adjacent cells' do
    it 'returns correct results' do
      table = Table.new 5, 5
      table.north_of(0, 0).must_equal Placement.new(0, 1, ORIENTATIONS::NORTH)
      table.north_of(0, 4).must_be_nil

      table.east_of(0, 0).must_equal Placement.new(1, 0, ORIENTATIONS::EAST)
      table.east_of(4, 0).must_be_nil

      table.south_of(4, 4).must_equal Placement.new(4, 3, ORIENTATIONS::SOUTH)
      table.south_of(0, 0).must_be_nil

      table.west_of(4, 0).must_equal Placement.new(3, 0, ORIENTATIONS::WEST)
      table.west_of(0, 0).must_be_nil
    end
  end

  describe 'when converted to a string' do
    it 'returns an ASCII grid' do
      Table.new(1, 1).to_s.must_equal <<-EOS

╔═══╗
║   ║
╚═══╝
      EOS

      Table.new(2, 2).to_s.must_equal <<-EOS

╔═══╤═══╗
║   │   ║
╟───┼───╢
║   │   ║
╚═══╧═══╝
      EOS

      Table.new(3, 3).to_s.must_equal <<-EOS

╔═══╤═══╤═══╗
║   │   │   ║
╟───┼───┼───╢
║   │   │   ║
╟───┼───┼───╢
║   │   │   ║
╚═══╧═══╧═══╝
      EOS

      Table.new(12, 6).to_s.must_equal <<-EOS

╔═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╗
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╚═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╝
      EOS
    end
  end

  describe 'when converted to a string with a coordinate' do
    it 'returns an ASCII grid marking the coordinate' do
      Table.new(1, 1).to_s(Placement.new(0, 0, EAST)).must_equal <<-EOS

╔═══╗
║ ▶ ║
╚═══╝
      EOS

      Table.new(2, 2).to_s(Placement.new(1, 0, NORTH)).must_equal <<-EOS

╔═══╤═══╗
║   │   ║
╟───┼───╢
║   │ ▲ ║
╚═══╧═══╝
      EOS

      Table.new(3, 3).to_s(Placement.new(1, 2, WEST)).must_equal <<-EOS

╔═══╤═══╤═══╗
║   │ ◀ │   ║
╟───┼───┼───╢
║   │   │   ║
╟───┼───┼───╢
║   │   │   ║
╚═══╧═══╧═══╝
      EOS

      Table.new(12, 6).to_s(Placement.new(7, 3, SOUTH)).must_equal <<-EOS

╔═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╗
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │ ▼ │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢
║   │   │   │   │   │   │   │   │   │   │   │   ║
╚═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╝
      EOS
    end
  end
end
