module Opstat
module Plugins
class Network < Task
  STAT_FILE = "/proc/net/dev"

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    report = []
    File.open(STAT_FILE).each do |line|
        report << line
    end
    return report
  end

end
end
end
