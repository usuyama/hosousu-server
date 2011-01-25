# -*- coding: utf-8 -*-
#!/usr/bin/ruby

require "socket"

sock = TCPSocket.open("webbie.bz", 31410)

buf = sock.recv 512
p buf
p "connect-ok"
sock.print "connect-ok"
buf = sock.recv 12
p buf
t1 = Thread.new do
  p "th1"
  while (buf = sock.read 6)
    p buf
    if buf =~ /(win |lose)(\d+)/
      sock.print "ok"
    end
  end
end
t2 = Thread.new do
  p "th2"
  sock.print "next01"
  sock.print "next01"
  sock.print "next02"
  sock.print "next02"
  sock.print "next03"
  sock.print "next10"
  sock.print "next11"
end
t1.join
t2.join
sock.close

# 送信が終わったらソケットを閉じる


