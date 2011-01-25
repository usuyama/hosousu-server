require 'config'
require 'user'
require 'lib'
require 'thread'
require 'timeout'

TCPServer.open USER_SERVER_PORT do |server|
  puts "\t" + USER_SERVER_NAME
  loop do
    begin
      sock = server.accept
      log "###sock accept"
      message = sock.recv RECV_MAX
      data = message.split ','
      log data
      case data.first.to_sym
      when :register
        if User.find_by_name data[1]
          sock.print "already_taken"
        else
          if user = (User.create :name => data[1])
            sock.print "ok," + format("%05d", user.id)
          else
            sock.print "fail"
          end
        end
      when :change_name
        if user = (User.find_by_id data[1])
          user.update_attribute :name, data[2]
          sock.print "ok"
        else
          sock.print "unknown_id"
        end
      when :find_by_id
        if user = (User.find_by_id data[1])
          sock.print "ok," + user.pack
        else
          sock.print "unknown_id"
        end
      when :find_by_name
        if user = (User.find_by_name data[1])
          sock.print "ok," + user.pack
        else
          sock.print "unknown_name"
        end
      when :set_score
        if user = (User.find_by_id data[1]) && user.highscore < data[2].to_i
          user.update_attribute :highscore, data[2]
          sock.print "ok"
        else
          sock.print "unknown_id"
        end
      else
        sock.print "unsupported_protocol"
      end
      sock.recv 2
    rescue => exc
      p exc
    ensure
      sock.close
      log "###sock close"
    end
  end
end
