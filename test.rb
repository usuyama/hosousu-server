require 'config'

class User < ActiveRecord::Base
  attr_accessor :user_pair
  attr_accessor :message_queue
  attr_accessor :socket
  attr_accessor :messages

  def init(up=nil, sock=nil)
    @user_pair = up
    @message_queue = Queue.new
    @messages = Array.new
    @socket = sock
  end

  def pack
    sprintf "%05d,%s,%05d,%04d", self.id, self.name,self.highscore,self.rate
  end


end

User.create :name => "aaa"
