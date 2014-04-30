class Locobot

  COMMANDS = {
    HELP: 'List available commands',
    PLACE: 'Set robots positions',
    MOVE: 'Move forward in current direction',
    LEFT: 'Rotate 90 degrees left',
    RIGHT: 'Rotate 90 degrees right',
    REPORT: 'Announce current position and orientation'
  }
  MODES    = %w{READY SHUTTINGDOWN}

  def initialize
    @status = MODES.first
  end

  attr_accessor :x, :y, :orientation

  def execute command
    # command = command.upcase
    if COMMANDS.keys.include? command.to_sym
      self.send command.downcase
    else
      unknown_command command
    end
  end

  def shutting_down?
    @status == MODES.last
  end

  private

  def help
    COMMANDS.map do |command|
      "#{command[0]}\t#{command[1]}"
    end.join "\n"
  end

  def unknown_command command
    "Unknown command #{command}".upcase
  end

  def method_missing a
    unknown_command a
  end

end
