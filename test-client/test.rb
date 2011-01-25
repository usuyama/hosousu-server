# -*- coding: utf-8 -*-
class User
  attr_accessor :state
  def initialize
    @recv_buf = [] #クライアントから受信したものをためる
    @state = :connect
  end

  def receive(message)
    @recv_buf.push message
  end

  def pop_message
    @recv_buf.pop
  end
end

class UserPair
  def initialize(user1, user2)
    @pair = [user1, user2]
  end

  def first
    @pair.first
  end

  def second
    @pair[1]
  end
end

user_pair = [].push UserPair.new(User.new, User.new)


t1 = Thread.new do
  for i in 0..10
    user_pair.first.first.receive "next" + format("%02d", i)
    sleep 0.1
  end
end
t2 = Thread.new do
  loop do
    if x = user_pair.first.first.pop_message
      p x + "user0"
      if x == "next09" then
        break
      end
    end
      sleep 0.1
  end
end
t3 = Thread.new do
  for i in 0..10
    user_pair.first.second.receive "next" + format("%02d", i)
    sleep 0.1
  end
end
t4 = Thread.new do
  loop do
    if x = user_pair.first.second.pop_message
      p x + "user1"
      if x == "next09" then
        break
      end
    end
      sleep 0.1
  end
end

[t1,t2,t3,t4].each do |i|
  i.join
end
