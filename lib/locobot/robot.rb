require './lib/locobot/constants'
require './lib/locobot/table'
require './lib/locobot/placement'
include Locobot
include Locobot::ORIENTATIONS
include Locobot::STATUS

module Locobot
  # Main robot class. Interprets string commands. Returns responses
  # @author Nick Butler
  # @attr [Locobot::Table] table the table the robot will be placed upon
  # @attr_reader [String] status (Locobot::STATUS) describing the robot's state
  # @attr_reader [Locobot::Placement] placement describes the robot's current
  #   position
  class Robot
    include STATUS

    def initialize
      @status = READY
    end

    attr_accessor :table
    attr_reader :status, :placement

    # Intereprets string commands
    # @param [String] command to be interpreted and executed if possible
    # @return [String, nil] the robot's response or nil if there is an error
    def execute(command)
      command, *args = command.split(/[ ,]+/)
      if COMMANDS.constants.include? command.to_sym
        send command.downcase, *args unless no_table?
      else
        (@status = UNRECOGNISED_COMMAND) && nil
      end
    rescue
        (@status = INVALID_COMMAND_FORMAT) && nil
    end

    def shutting_down?
      @status == SHUTTINGDOWN
    end

    private

    # MAIN COMMANDS

    # Describe acceptable robot commands
    # @private
    # @return [String] generated from (Locobot::COMMANDS)
    def help
      COMMANDS.constants.map do |command|
        "#{command}\t#{COMMANDS.const_get command}"
      end.join "\n"
    end

    # Place the robot somewhere on it's table if possible
    # @param [Integer] x coordinate
    # @param [Integer] y coordinate
    # @param [String] orientation from (Locobot::ORIENTATIONS)
    # @return [String, nil] (Locobot::COMMAND_SUCCESSFUL) or nil if error
    def place(x = nil, y = nil, orientation = nil)
      placement = Placement.new x, y, orientation
      (@status = INVALID_PLACEMENT) && return unless placement.valid?

      if table.coordinate_exists? placement.x, placement.y
        @placement = placement
        @status = COMMAND_SUCCESSFUL
      else
        (@status = MOVEMENT_IMPOSSIBLE) && nil
      end
    end

    # Move robot one cell in the direction being faced if pssible
    # @return [String, nil] (Locobot::COMMAND_SUCCESSFUL) or nil if error
    def move
      return unless check_placement
      new_placement = table.cell_to(placement)
      if new_placement
        @placement = new_placement
        @status = COMMAND_SUCCESSFUL
      else
        (@status = MOVEMENT_IMPOSSIBLE) && nil
      end
    end

    # Turn robot 90 degrees to it's left
    # @return [String, nil] (Locobot::COMMANDS::COMMAND_SUCCESSFUL) or nil if
    #   error
    def left
      return unless check_placement
      placement.turn_left
      COMMAND_SUCCESSFUL
    end

    # Turn robot 90 degrees to it's right
    # @return [String, nil] (Locobot::COMMAND_SUCCESSFUL) or nil if error
    def right
      return unless check_placement
      placement.turn_right
      COMMAND_SUCCESSFUL
    end

    # Report the robots current position on it's (Locobot::Table)
    # @return [String] ascii depiction of (Locobot::Table) with robot's current
    #   position and orientation followed by text description of the same
    def report
      check_placement && "#{table.to_s(placement)}#{placement}"
    end

    def exit
      @status = SHUTTINGDOWN
      COMMAND_SUCCESSFUL
    end

    # Sets status to NO_TABLE if there's no table
    # @return [Boolean]
    def no_table?
      if table
        false
      else
        @status = NO_TABLE
        true
      end
    end

    # Sets status to NOT_PLACED unless placed
    # @return [True, nil] true if robot is placed nil and set status to
    #   Locobot::STATUS::NOT_PLACED if not placed
    def check_placement
      if placement && placement.valid?
        true
      else
        (@status = NOT_PLACED) && return
      end
    end

    # Hangle unrecognised commands
    # @param [Array] _ any parameters passed are ignored
    # @retrn [String] (Locobot::STATUS::UNRECOGNISED_COMMAND)
    def method_missing(*_)
      @status = UNRECOGNISED_COMMAND
    end
  end
end
