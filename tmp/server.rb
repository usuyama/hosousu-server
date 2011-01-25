#!/usr/bin/ruby

require 'benchmark'

require "socket"

s0 = TCPServer.open(31410)
# クライアントからの接続を受け付ける
sock = s0.accept
p "sock accept"
# sock.peeraddr
  sock.write "HELLO"
#  p sock.peeraddr
  # クライアントからのデータを最後まで受信する
  # 受信したデータはコンソールに表示される
  buf = sock.gets
p Benchmark.measure {
  sock.write "HELLO"
  buf = sock.gets
}
# クライアントとの接続ソケットを閉じる
sock.close

# 待ちうけソケットを閉じる
s0.close

