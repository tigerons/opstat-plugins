module Opstat
module Plugins
class Bsdnet < Task
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
