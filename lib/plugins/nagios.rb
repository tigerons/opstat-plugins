module Opstat
module Plugins
class Nagios < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    report = []
    xmlIO = IO.popen('/usr/sbin/nagiostats')
    report  = xmlIO.readlines
    xmlIO.close
    return report
  end

end
end
end

