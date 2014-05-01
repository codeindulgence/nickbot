require 'highline/import'
require 'debugger'

require File.expand_path('../../lib/locobot',  __FILE__)
require File.expand_path('../../lib/table',  __FILE__)

@locobot = Locobot::Robot.new
@locobot.table = Table.new 5, 5

def coloured string, colour
  "<%= color(\"#{string}\", #{colour}) %>"
end

def prompt
  command = ask(coloured('LOCOBOT AWAITING COMMAND> ', :BLUE)) { |q| q.case = :upcase }

  unless command.empty?
    response = @locobot.execute(command)

    if response
      say coloured("#{response}", :GREEN)
    else
      say coloured("ERROR: #{@locobot.error}", :RED)
    end
  end

  prompt unless @locobot.shutting_down?
end

prompt
