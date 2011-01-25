class User < ActiveRecord::Base
  def pack
    sprintf "%05d,%s,%05d,%04d", self.id, self.name,self.highscore,self.rate
  end
end
