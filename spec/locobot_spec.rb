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

end
