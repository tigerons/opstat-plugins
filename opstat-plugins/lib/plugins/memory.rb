module Opstat
module Plugins
class Memory < Task
  STAT_FILE = "/proc/meminfo"

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    @count_number += 1
    report = File.open(STAT_FILE).readlines
    return report
  end
end
end
end
