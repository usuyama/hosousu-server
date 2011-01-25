require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'logger'
require 'benchmark'

ActiveRecord::Base.logger = Logger.new "log"

ActiveRecord::Base.establish_connection(
                                        :adapter => "sqlite3",
                                        :database  => "keisan.sqlite"
                                        )

MESSAGE = {
  :ok => "ok",
  :fail => "fail",
  :already_taken => "already_taken"
}

USER_SERVER_NAME = "HOSOUSU-SERVER for USER"
USER_SERVER_PORT = 31410
RECV_MAX = 256
