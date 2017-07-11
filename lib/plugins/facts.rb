#set default FACTERDIR - omit libfacter not found on some systems
ENV['FACTERDIR'] ||= '/usr/lib'
require 'facter'

module Opstat
module Plugins
class Facts < Task

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
