class User < ActiveRecord::Base
  attr_accessor :user_pair
  attr_accessor :socket
  attr_accessor :messages
  attr_accessor :pipe_thread

  def init(up=nil, sock=nil)
    @user_pair = up
    @messages = Array.new
    @socket = sock
  end

  def pack
    sprintf "%05d,%s,%05d,%04d", self.id, self.name,self.highscore,self.rate
  end

  def score #calc from messages
    1000
  end

end
