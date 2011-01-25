#!/usr/bin/ruby
require 'config'
require 'user'
require 'lib'
require 'thread'
require 'timeout'
require 'user_pair'

class BattleServer
  def initialize mode
    @mode = mode
    @user_queue = Queue.new
    @thread_count = 0
    @locker = Mutex::new
    self.start
  end

  def push(user_sock_pair)
    p "push"
    p user_sock_pair
    @user_queue.push user_sock_pair
  end

  def start
    Thread.new do
      loop do
        u1 = @user_queue.pop
        u2 = @user_queue.pop
        Thread.new do
          user_pair = UserPair.new u1, u2
          user_pair.send_opponent_info
          user_pair.recv_ok
          user_pair.send_problem_set @mode
          user_pair.recv_ok
          user_pair.send_start
          user_pair.game_start
          user_pair.game_end
          user_pair.recv_ok
          user_pair.close_socket
        end
      end
    end
  end
end

servers = { :easy => BattleServer.new(:easy), :normal => BattleServer.new(:normal), :hard => BattleServer.new(:hard) }
TCPServer.open BATTLE_SERVER_PORT do |server|
  puts "\t" + BATTLE_SERVER_NAME
  loop do
    sock = server.accept
    puts "sock accept"
    buf = sock.recv RECV_MAX
    user_prof = buf.split ','
    p user_prof
    if u = (User.find_by_id user_prof.first)
      if s = servers[user_prof[1].to_sym]
        s.push({:user => u, :socket => sock })
      else
        sock.print "unknown_mode"
      end
    else
      sock.print "unknown_id"
    end
  end
end
