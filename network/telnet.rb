# vim: set shiftwidth=2 tabstop=2 noexpandtab noautoindent
require 'socket'
require 'net/telnet'
require 'timeout'

module Network
	class Telnet
		NT = ::Net::Telnet
		T_INIT = [
			NT::IAC + NT::DO + NT::OPT_TTYPE,
			NT::IAC + NT::SB + NT::OPT_TTYPE + NT::OPT_ECHO + NT::IAC + NT::SE,
			NT::IAC + NT::WILL + NT::OPT_ECHO,
			NT::IAC + NT::WILL + NT::OPT_SGA
		]

		@port = nil
		@server = nil
		def initialize(port = 23)
			@port = port.is_a?(Fixnum) ? port : 23
		end

		def listen
			@server = TCPServer.new @port
			Thread.start do
				loop do
					Thread.start(@server.accept) { |c|
						# telnet init
						for cmd in T_INIT
							c.send cmd, 0
							begin
								timeout(1) { c.recv 64 }
							rescue Timeout::Error
								IO.select [c]
							end
						end

						# term init
						c.send NT::IAC + NT::DO + NT::OPT_NAWS, 0
						buf = ""
						begin
							timeout(1) { buf = c.recv 64 }
						rescue Timeout::Error
							IO.select [c]
						end

						if buf[0] == NT::IAC and buf[2] == NT::OPT_NAWS
							rcv = 3 if buf[1] == NT::SB # for unix telnet with port
							if buf[1] == NT::WILL
								rcv = 6 if buf[3..5] == NT::IAC + NT::SB + NT::OPT_NAWS
								unless buf[3] == NT::IAC
									k = []
									begin
										timeout(1) { k = c.recv 64 }
									rescue Timeout::Error
										IO.select [c]
									end
									buf[3..-1] = k
								end
							end
						end

						if rcv.nil?
							b_lines = 23
							b_cols = 79
						else
							b_lines = [buf[(rcv + 2)..(rcv + 3)].reverse.unpack "S", 23].max
							b_cols = [buf[rcv..(rcv + 1)].reverse.unpack "S", 79].max
						end

						yield c, [:lines => b_lines, :cols => b_cols]
					}
				end
			end
		end
	end
end
