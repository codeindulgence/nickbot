require 'highline/import'
require 'debugger'

require File.expand_path('../../lib/locobot',  __FILE__)
@locobot = Locobot.new

def prompt
  command = ask("<%= color('LOCOBOT AWAITING COMMAND> ', BLUE) %>") { |q| q.case = :upcase }

  say @locobot.execute command

  prompt unless @locobot.shutting_down?
end

prompt
