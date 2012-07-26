# vim: set shiftwidth=2 tabstop=2 noexpandtab noautoindent
require 'socket'

module Network
	class Telnet
		@port = nil
		@server = nil
		def initialize(port = 23)
			@port = port.is_a?(Fixnum) ? port : 23
		end

		def listen
			@server = TCPServer.new @port
			Thread.start do
				loop do
					Thread.start(@server.accept) { |c| yield c }
				end
			end
		end
	end
end
