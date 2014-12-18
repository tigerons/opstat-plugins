module Opstat
module Plugins
class Bsdnet < Task
  attr_accessor :interval

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    io = IO.popen("pfctl -sinfo")
    report = io.readlines
    io.close
    return report
  end
end
end
end
#TODO check if stats are activated - set logininterfacep works only for one interface
