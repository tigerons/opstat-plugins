module Opstat
module Plugins
class Temper < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    report = []
    temperIO = IO.popen('/usr/bin/temper')
    report  = temperIO.readlines.to_s
    temperIO.close
    return report
  end

end
end
end
#TO CHECK - temper cmd
