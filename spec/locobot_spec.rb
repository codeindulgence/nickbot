require 'minitest/spec'
require 'minitest/autorun'

require './lib/locobot'

describe Locobot do

  before do
    @locobot = Locobot.new
  end

  # describe "when placed" do
  #   it "tells me it needs a tabletop" do
  #     @locobot.place 0, 0, 'N'
  #   end
  # end
end
