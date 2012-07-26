# vim: set shiftwidth=2 tabstop=2 noexpandtab noautoindent
require 'iconv'
require 'socket'

server = TCPServer.new 12000
loop do
#  Thread.start(server.accept) do |client|
  Thread.start(server.accept) do |client|
    client.puts "Hello !"
    client.puts "Time is #{Time.now}"
    client.close
  end
end

