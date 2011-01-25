#!/usr/bin/ruby
require 'benchmark'
require 'socket'
require 'prob.rb'
require 'thread'

user1_queue = Queue.new
user2_queue = Queue.new
s0 = TCPServer.open(31410)
# クライアントからの接続を受け付ける
sock1 = s0.accept
p "sock1 accept"
sock2 = s0.accept
p "sock2 accept"
# sock.peeraddr
buf = problem 10
sock1.print buf
sock2.print buf
p buf
p "send problem"
unless (l = sock1.recv 12) == "connect-ok"
  raise l
end
unless (l = sock2.recv 12) == "connect-ok"
  raise l
end
sock1.print "game-start"
sock2.print "game-start"
p "game-start"

winner = nil
t_recv1 = Thread.new do
  while (!winner) && (l = sock1.recv 6)
    user1_queue.push l
    p l + "(recv from user1)"
    if l =~ /^next(\d+)/
      if $1.to_i == 9
        #user1 win
        unless winner
          winner = 1
        end
      end
    end
  end
end
t_recv2 = Thread.new do
  while (!winner) && (l = sock2.recv 6)
    user2_queue.push l
    p l + "(recv from user2)"
    if l =~ /^next(\d+)/
      if $1.to_i == 9
        #user2 win
        unless winner
          winner = 2
        end
      end
    end
  end
end

t_send1 = Thread.new do
  loop do
    l = user1_queue.pop
    sock1.print l
  end
end

t_send2 = Thread.new do
  loop do
    l = user2_queue.pop
    sock1.print l
  end
end

t_recv1.join
t_recv2.join
t_send1.kill
t_send2.kill

p "win/lose"
if winner == 1
  sock1.print "win 10"
  sock2.print "lose10"
else
  sock1.print "lose10"
  sock2.print "win 10"
end
while (l = sock1.read 2)
  if l == "ok"
    break
  end
end
sock1.close
while (l = sock2.read 2)
  if l == "ok"
    break
  end
end
# クライアントとの接続ソケットを閉じる
sock2.close

# 待ちうけソケットを閉じる
s0.close

