require './lib/locobot/constants'
require './lib/locobot/table'
require './lib/locobot/placement'
include Locobot
include Locobot::ORIENTATIONS
include Locobot::STATUS

module Locobot
  # Main robot class. Interprets string commands
  class Robot
    include STATUS

    def initialize
      @status = READY
    end

    attr_accessor :status, :placement, :table, :error

    def execute(command)
      command, *args = command.split(/[ ,]+/)
      if COMMANDS.constants.include? command.to_sym
        send command.downcase, *args unless no_table?
      else
        (self.error = UNRECOGNISED_COMMAND) && nil
      end
    end

    def shutting_down?
      status == SHUTTINGDOWN
    end

    private

      # MAIN COMMANDS

      # Describe acceptable robot commands
    def help
      COMMANDS.constants.map do |command|
        "#{command}\t#{COMMANDS.const_get command}"
      end.join "\n"
    end

    def place(x = nil, y = nil, orientation = nil)
      placement = Placement.new x, y, orientation
      (self.error = INVALID_PLACEMENT) && return unless placement.valid?

      if table.coordinate_exists? placement.x, placement.y
        self.placement = placement
        self.status = COMMAND_SUCCESSFUL
      else
        (self.error = MOVEMENT_IMPOSSIBLE) && nil
      end
    end

    def move
      return unless check_placement
      new_placement = table.cell_to(placement)
      if new_placement
        self.placement = new_placement
        self.status = COMMAND_SUCCESSFUL
      else
        (self.error = MOVEMENT_IMPOSSIBLE) && nil
      end
    end

    def left
      return unless check_placement
      placement.turn_left
      COMMAND_SUCCESSFUL
    end

    def right
      return unless check_placement
      placement.turn_right
      COMMAND_SUCCESSFUL
    end

    def report
      check_placement && "#{table.to_s(placement)}#{placement}"
    end

    def exit
      self.status = SHUTTINGDOWN
      COMMAND_SUCCESSFUL
    end

      # Internal methods

      # Sets status to NO_TABLE if there's no table
    def no_table?
      if table
        false
      else
        self.error = NO_TABLE
        true
      end
    end

      # Sets status to NOT_PLACED unless placed
    def check_placement
      if placement && placement.valid?
        true
      else
        (self.error = NOT_PLACED) && return
      end
    end

      # Hangle unrecognised commands
    def method_missing(*_)
      self.error = UNRECOGNISED_COMMAND
    end
  end
end
