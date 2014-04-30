module Locobot

  module COMMANDS
    HELP   = 'List available commands'
    PLACE  = 'Set robots positions'
    MOVE   = 'Move forward in current direction'
    LEFT   = 'Rotate 90 degrees left'
    RIGHT  = 'Rotate 90 degrees right'
    REPORT = 'Announce current position and orientation'
  end

  module STATUS
    READY = "READY"
    NO_TABLE = "NO TABLE"
    NOT_PLACED = "NOT PLACED"
    SHUTTINGDOWN = "SHUTTINGDOWN"
  end

  module ORIENTATIONS
    NORTH = :N
    EAST  = :E
    SOUTH = :S
    WEST  = :W
  end

  class Robot

    def initialize
      @status = STATUS::READY
    end

    attr_accessor :x, :y, :orientation, :table, :error

    def execute command, *params
      if Locobot::COMMANDS.constants.include? command.to_sym
        self.send command.downcase, *params
      else
        unknown_command command
      end
    end

    def shutting_down?
      @status == MODES::SHUTTINGDOWN
    end

    private

      # MAIN COMMANDS

      # Describe acceptable robot commands
      def help
        Locobot::COMMANDS.constants.map do |command|
          "#{command}\t#{Locobot::COMMANDS.const_get command}"
        end.join "\n"
      end

      def place x, y, orientation
        unless no_table?
          self.x = x
          self.y = y
          self.orientation = orientation
        end
      end

      def move
        check_placement
      end

      def left
        check_placement
      end

      def right
        check_placement
      end

      def report
        check_placement
      end

      # Internal methods

      # Sets status to NO_TABLE if there's no table
      def no_table?
        if @table
          false
        else
          self.error = STATUS::NO_TABLE
          true
        end
      end

      # Sets status to NOT_PLACED unless placed
      def check_placement
        self.error = STATUS::NOT_PLACED and return unless self.x and self.y and self.orientation
      end

      def unknown_command command
        "Unknown command: #{command}".upcase
      end

      def method_missing *a
        unknown_command a * ' '
      end

  end
end
