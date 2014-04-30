require 'highline/import'
require 'debugger'

require File.expand_path('../../lib/locobot',  __FILE__)
@locobot = Locobot::Robot.new

def prompt
  command = ask("<%= color('LOCOBOT AWAITING COMMAND> ', BLUE) %>") { |q| q.case = :upcase }

  puts((@locobot.execute(command) or "ERROR: #{@locobot.error}"))

  prompt unless @locobot.shutting_down?
end

prompt
