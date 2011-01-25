require "socket"

sock = TCPSocket.open("webbie.bz", 31410)
sock.print "find_by_name,usuyama"
p sock.recv 256
sock.print "ok"
sock.close
