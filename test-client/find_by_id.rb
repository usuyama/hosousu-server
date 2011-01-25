require "socket"

sock = TCPSocket.open("webbie.bz", 31410)
sock.print "find_by_id,1"
p sock.recv 256
sock.print "ok"
sock.close
