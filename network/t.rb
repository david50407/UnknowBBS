# vim: set shiftwidth=2 tabstop=2 noexpandtab noautoindent
require 'socket'
require 'net/telnet'

module Network
	class Telnet
    SC = ::Socket::Constants
    NT = ::Net::Telnet
		T_INIT = [
			NT::IAC + NT::DO + NT::OPT_TTYPE,
			NT::IAC + NT::SB + NT::OPT_TTYPE + NT::OPT_ECHO + NT::IAC + NT::SE,
			NT::WILL + NT::OPT_ECHO,
			NT::WILL + NT::OPT_SGA
		]

		@port = nil
		@server = nil
		def initialize(port = 23)
			@port = port.is_a?(Fixnum) ? port : 23
		end

		def listen
      Thread.new {
        @server = Socket.new(SC::AF_INET, SC::SOCK_STREAM, SC::IPPROTO_TCP)
        @server.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
        @server.setsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER, false)
        sockaddr = Socket.pack_sockaddr_in 12000, '0.0.0.0' # WTF C socket!?
        @server.bind sockaddr
        @server.listen 5
        c, ca = @server.accept_nonblock
			}
		end
	end
end
