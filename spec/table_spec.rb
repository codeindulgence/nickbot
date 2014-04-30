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
end

