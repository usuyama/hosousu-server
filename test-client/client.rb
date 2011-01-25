# -*- coding: utf-8 -*-
#!/usr/bin/ruby

require "socket"

sock = TCPSocket.open("webbie.bz", 31411)
sock.print "1,easy"
p sock.recv 512
sock.print "ok"
p sock.recv 512
sock.print "ok"
p sock.recv 5

t1 = Thread.new do
  p "th1"
  while (buf = sock.recv 6)
    p buf
    if buf =~ /(w|l)_(\d+)/
      sock.print "ok"
      break
    end
  end
end

t2 = Thread.new do
  p "th2"
  sock.print "next01"
  sock.print "next02"
  sock.print "next03"
  sock.print "next04"
  sock.print "next05"
  sock.print "next06"
  sock.print "next07"
  sock.print "next08"
  sock.print "next09"
  sock.print "finish"
  p "send finish"
end
t1.join
t2.join
sock.close

# 送信が終わったらソケットを閉じる


