module Opstat
module Plugins
class Temper < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    temperIO = IO.popen('/usr/bin/temper')
    report  = temperIO.readlines
    temperIO.close
    return report[0].to_s
  end

end
end
end
#TO CHECK - temper cmd

