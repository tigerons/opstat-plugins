module Opstat
module Plugins
class DiskIo < Task
  READ_FILE = "/proc/diskstats"

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    @count_number += 1
    report = File.open(READ_FILE).readlines
    return report
  end
end
end
end
