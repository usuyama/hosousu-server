class UserPair
  attr_accessor :winner
  def initialize(us1, us2)
    p "init userpair"
    @user1 = us1[:user]
    @user2 = us2[:user]
    @sock1 = us1[:socket]
    @sock2 = us2[:socket]
    @winner = nil
    @user1.init self, @sock1
    @user2.init self, @sock2
    p "init userpair end"
  end

  def opponent(user)
    p "def opponent"
    if @user1.object_id == user.object_id
      @user2
    else
      @user1
    end
  end

  def send_opponent_info
    p "opponent info"
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
    p "problem send"
    @problem_set = generate_problem mode, PROBLEM_COUNT
    p "problem send"
    p @problem_set
    self.print_both @problem_set
  end

  def send_start
    self.print_both "start"
  end

  def game_start
    p "game start"
    @user1.gen_thread_for_push_message_for_opponent
    @user2.gen_thread_for_push_message_for_opponent
    p "gen_push_thread"
    th_pop_user1 = @user1.gen_thread_for_pop_message
    th_pop_user2 = @user2.gen_thread_for_pop_message
    p "gen pop thread"
    @user1.thread_for_push_message.join
    @user2.thread_for_push_message.join
    p "kill"
    th_pop_user1.kill
    th_pop_user2.kill
  end

  def loser
    self.opponent(@winner)
  end

  def game_end
    p "game_end"
    @winner.socket.printf "w_%04d", @winner.score
    p "winner"
    self.loser.socket.printf "l_%04d", self.loser.score
  end

  def close_socket
    p "close_socket"
    @user1.socket.close
    @user2.socket.close
  end
end
