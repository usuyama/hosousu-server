require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'logger'
require 'benchmark'
require 'thread'

ActiveRecord::Base.logger = Logger.new "log"

ActiveRecord::Base.establish_connection(
                                        :adapter => "sqlite3",
                                        :database  => "keisan.sqlite"
                                        )

USER_SERVER_NAME = "HOSOUSU-SERVER for USER"
USER_SERVER_PORT = 31410
BATTLE_SERVER_NAME = "HOSOUSU-SERVER for BATTLE"
BATTLE_SERVER_PORT = 31411
RECV_MAX = 512
PROBLEM_COUNT = 10

MAX_THREAD_COUNT = 10 #一つのモードで同時対戦できる最大数(未実装)
Thread.abort_on_exception = true

=begin
#困っていること
thread内での例外が何も言わないで消える...。時がある？？？
class Socket
  def print
    でoverrideできない。

#todo
例外処理。
スコア計算
rate計算
対戦成績
=end
