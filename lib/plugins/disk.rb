module Opstat
module Plugins
class Disk < Task
  attr_accessor :interval

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  #TODO in memory module io.close
  def parse
    @count_number += 1
    report = {}
    io = IO.popen('df --output=source,fstype,used,avail,itotal,iused,iavail,target')
    report = io.readlines
    io.close
    return report
  end
end
end
end
#check - df has some requirements  to work with --output - problems on RHEL
