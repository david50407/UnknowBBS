# vim: set shiftwidth=2 tabstop=2 noexpandtab noautoindent
require 'network/telnet.rb'

def main
  @nets = [Network::Telnet.new(12000)]

  for n in @nets
    n.listen { |c|
      c.puts "Hello !"
      c.puts "Time is #{Time.now}"
      c.close
    }
  end
end

main
loop do
  sleep 60
end
