require "socket"

sock = TCPSocket.open("webbie.bz", 31410)
sock.print "change_name,1,hosokawa"
p sock.recv 256
sock.print "ok"
sock.close
