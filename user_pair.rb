class UserPair
  attr_accessor :winner

  def initialize(us1, us2)
    @user1 = us1[:user]
    @user2 = us2[:user]
    @sock1 = us1[:socket]
    @sock2 = us2[:socket]
    @winner = nil
    @user1.init self, @sock1
    @user2.init self, @sock2
  end

  def opponent(user)
    if @user1.object_id == user.object_id
      @user2
    else
      @user1
    end
  end

  def send_opponent_info
    p "send opponent info"
    @sock1.printf "%04d,%s", @user2.rate, @user2.name
    @sock2.printf "%04d,%s", @user1.rate, @user1.name
  end

  def print_both buf
    @sock1.print buf
    @sock2.print buf
  end

  def recv_ok
    p "recv ok"
    p @sock1.recv 2
    p @sock2.recv 2
  end

  def send_problem_set mode
    @problem_set = generate_problem mode, PROBLEM_COUNT
    p "problem send"
    p @problem_set
    self.print_both @problem_set
  end

  def send_start
    self.print_both "start"
  end

  def gen_thread_for_pipe(user1, user2) #user1 -> user2
    user1.pipe_thread = Thread.new do
      while !@winner && (l = user1.socket.recv 6)
        user1.messages.push l
        if l =~ /next(\d+)/
          user2.socket.print l
        elsif l == "finish"
          if @winner.nil?
            @winner = user1
          end
          #kill thread because of passing block-recv
          user2.pipe_thread.kill
          Thread.exit
        end
      end
    end
  end

  def game_start
    t1 = gen_thread_for_pipe @user1, @user2
    t2 = gen_thread_for_pipe @user2, @user1
    t1.join
    t2.join
  end

  def loser
    self.opponent(@winner)
  end

  def game_end
    p "game_end"
    @winner.socket.printf "w_%04d", @winner.score
    self.loser.socket.printf "l_%04d", self.loser.score
  end

  def close_socket
    p "close_socket"
    @user1.socket.close
    @user2.socket.close
  end
end
