module Opstat
module Plugins
class Cpu < Task
  CPU_REGEX = /^cpu.*/
  STAT_FILE = "/proc/stat"

  def parse
    report = Array.new
    File.open(STAT_FILE).each do |line|
      if line.match(CPU_REGEX)
        report << line
      end
    end
    return report
  end

end
end
end
