class User < ActiveRecord::Base
  attr_accessor :user_pair
  attr_accessor :message_queue
  attr_accessor :socket
  attr_accessor :messages
  attr_accessor :thread_for_push_message
  def init(up=nil, sock=nil)
    @user_pair = up
    @message_queue = Queue.new
    @messages = Array.new
    @socket = sock
  end

  def pack
    sprintf "%05d,%s,%05d,%04d", self.id, self.name,self.highscore,self.rate
  end

  def gen_thread_for_push_message_for_opponent
    p "gen_thread_for_push_message_for_opponent"
    @thread_for_push_message = Thread.new {
      p "thread.new push th"
        while !@user_pair.winner && (l = @socket.recv 6)
        p "###recv " + l
        @messages.push l
        p "pushpush"
        p @user_pair.winner
        if l =~ /next(\d+)/
          @user_pair.opponent(self).message_queue.push l
        elsif l == "finish"
          p "l == finish"
          if @user_pair.winner.nil?
            @user_pair.winner = self
          end
          @user_pair.opponent(self).thread_for_push_message.kill
          p "opp thread kill"
          Thread.exit
          p "thread.exit"
        end
      end
      p "while nuketa"
    }
  end

  def gen_thread_for_pop_message
    p "gen_thread_for_pop_message"
    Thread.new do
      loop do
        l = @message_queue.pop
        p "pop " + l + " in pop th"
        @messages.push l
        @socket.print l
      end
    end
  end

  def score #calc from messages
    1000
  end

end
