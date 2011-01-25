require "socket"

sock = TCPSocket.open("webbie.bz", 31410)
sock.print "register,usuyama"
p sock.recv 256
sock.print "ok"
sock.close
