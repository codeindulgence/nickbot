require 'highline/import'
require 'debugger'

require File.expand_path('../../lib/locobot',  __FILE__)
require File.expand_path('../../lib/table',  __FILE__)

@locobot = Locobot::Robot.new
@locobot.table = Table.new 5, 5

def prompt
  command = ask("<%= color('LOCOBOT AWAITING COMMAND> ', BLUE) %>") { |q| q.case = :upcase }

  puts((@locobot.execute(command) or "ERROR: #{@locobot.error}"))

  prompt unless @locobot.shutting_down?
end

prompt
