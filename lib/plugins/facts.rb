module Opstat
module Plugins
class Facts < Task
  attr_accessor :interval

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  #TODO in memory module io.close
  def parse
    @count_number += 1
    return ::Facter.to_hash
  end
end
end
end
