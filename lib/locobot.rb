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
    NO_TABLE = 0
    NOT_PLACED = 1
  end

  module ORIENTATIONS
    NORTH = :N
    EAST  = :E
    SOUTH = :S
    WEST  = :W
  end

  class Robot

    MODES    = %w{READY SHUTTINGDOWN}

    def initialize
      @status = MODES.first
      @table = nil
      @error = nil
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
      @status == MODES.last
    end

    private

      def help
        Locobot::COMMANDS.constants.map do |command|
          "#{command}\t#{Locobot::COMMANDS.const_get command}"
        end.join "\n"
      end

      def place x, y, orientation
        self.error = STATUS::NO_TABLE and return unless @table
      end

      def unknown_command command
        "Unknown command: #{command}".upcase
      end

      def method_missing *a
        unknown_command a * ' '
      end

  end
end
