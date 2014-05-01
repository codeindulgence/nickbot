require 'highline/import'

require File.expand_path('../../lib/locobot',  __FILE__)
require File.expand_path('../../lib/table',  __FILE__)

@locobot = Locobot::Robot.new
@locobot.table = Table.new 5, 5

def coloured string, colour
  "<%= color(\"#{string}\", #{colour}) %>"
end

def prompt
  puts
  command = ask(coloured('LOCOBOT AWAITING COMMAND> ', :BLUE)) do |q|
    q.case = :upcase
    q.readline = true
  end
  puts

  unless command.empty?
    response = @locobot.execute(command)

    if response
      say coloured("#{response}", :GREEN)
    else
      say coloured("ERROR: #{@locobot.error}", :RED)
    end
  end

  prompt unless @locobot.shutting_down?

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
