require './lib/table'
require './lib/placement'

module Locobot

  module COMMANDS
    HELP   = 'List available commands'
    PLACE  = "Set robot's position. Syntax: X,Y,F"+"\n"+
     "        F can be one of: NORTH, SOUTH, EAST or WEST"
    MOVE   = 'Move forward in current direction'
    LEFT   = 'Rotate 90 degrees left'
    RIGHT  = 'Rotate 90 degrees right'
    REPORT = 'Announce current position and orientation'
  end

  module STATUS
    READY = "READY"
    COMMAND_SUCCESSFUL = "COMMAND SUCCESSFUL"
    NO_TABLE = "NO TABLE"
    NOT_PLACED = "NOT PLACED"
    INVALID_PLACEMENT = "INVALID PLACEMENT"
    MOVEMENT_IMPOSSIBLE = "MOVEMENT IMPOSSIBLE"
    UNRECOGNISED_COMMAND = "UNRECOGNISED COMMAND"
    SHUTTINGDOWN = "SHUTTINGDOWN"
  end

  class Robot

    def initialize
      @status = STATUS::READY
    end

    attr_accessor :placement, :table, :error

    def execute command
        command, *args = command.split(/[ ,]/)
        if Locobot::COMMANDS.constants.include? command.to_sym
          unless no_table?
            self.send command.downcase, *args
          end
        else
          self.error = STATUS::UNRECOGNISED_COMMAND and nil
        end
    end

    def shutting_down?
      self.status == STATUS::SHUTTINGDOWN
    end

    private

      # MAIN COMMANDS

      # Describe acceptable robot commands
      def help
        Locobot::COMMANDS.constants.map do |command|
          "#{command}\t#{COMMANDS.const_get command}"
        end.join "\n"
      end

      def place x = nil, y = nil, orientation = nil
        placement = Placement.new x, y, orientation
        self.error = STATUS::INVALID_PLACEMENT and return unless placement.valid?

        if table.coordinate_exists? placement.x, placement.y
          self.placement = placement
          self.status = STATUS::COMMAND_SUCCESSFUL
        else
          self.error = STATUS::MOVEMENT_IMPOSSIBLE and nil
        end
      end

      def move
        return unless check_placement
        if new_placement = self.table.cell_to(self.placement)
          self.placement = new_placement
          self.status = STATUS::COMMAND_SUCCESSFUL
        else
          self.error = STATUS::MOVEMENT_IMPOSSIBLE and nil
        end
      end

      def left
        return unless check_placement
        self.placement.turn_left
        STATUS::COMMAND_SUCCESSFUL
      end

      def right
        return unless check_placement
        self.placement.turn_right
        STATUS::COMMAND_SUCCESSFUL
      end

      def report
        check_placement and placement.to_s
      end

      # Internal methods

      # Sets status to NO_TABLE if there's no table
      def no_table?
        if self.table
          false
        else
          self.error = STATUS::NO_TABLE
          true
        end
      end

      def parse_orientation string
        false
      end

      # Sets status to NOT_PLACED unless placed
      def check_placement
        unless self.placement and self.placement.valid?
          self.error = STATUS::NOT_PLACED and return
        else
          true
        end
      end

      # Hangle unrecognised commands
      def method_missing *a
        self.error = STATUS::UNRECOGNISED_COMMAND
      end

  end
end
