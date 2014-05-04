require 'highline/import'
require File.expand_path('../../lib/locobot/robot',  __FILE__)

# Initialise our robot
@locobot = Locobot::Robot.new
begin
  @locobot.table = Table.new(*ARGV)
rescue
  puts 'Invalid table dimensions'
  puts 'Accepts two numbers greater than zero.'
  exit
end

# Convenience method for coloured output
# @param [String] string to output
# @param [Symbol] colour for output
# @return [String] ERB string for coloured output
def coloured(string, colour)
  "<%= color(\"#{string}\", #{colour}) %>"
end

# Actually prompt the user for a command
def ask_for_command
  ask(coloured('LOCOBOT AWAITING COMMAND> ', :BLUE)) do |q|
    q.case = :upcase
    q.readline = true
  end
end

# Initiate the prompt process and hendle the given input
def prompt
  command = ask_for_command
  unless command.empty?
    # Give the command to locobot
    response = @locobot.execute(command)
    if response
      # Print locobot's response
      say coloured("#{response}", :GREEN)
    else
      # Print locobot's status if response is nil
      say coloured("ERROR: #{@locobot.status}", :RED)
    end
  end

  # Unless locobot is shutting down, ask for another command
  @locobot.shutting_down? ? shutdown : prompt
end

# Locobot telling us what's going (it might be lying)

def shutdown
  sleep 0.3
  say coloured('POWERING DOWN MOTORS...', :RED)
  sleep 0.2
  say coloured('FLUSHING DATABANKS...', :RED)
  sleep 0.4
  say coloured('GOOD BYE', :GREEN)
  exit
end

say coloured('LOCOBOT INITIALIZING ', :RED)
10.times do
  say coloured('. ', :RED)
  sleep 0.25
end
puts
say 'LOCOBOT SYSTEMS READY'
sleep 1
say 'PLEASE OBSERVE COMMANDS LIST:'
sleep 0.2

say coloured(@locobot.execute('HELP'), :GREEN)

prompt
