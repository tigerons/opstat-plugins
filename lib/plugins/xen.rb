module Opstat
module Plugins
class Xen < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    report = {}
    xenIO = IO.popen('xentop -i 1 -b -f')
    report  = xenIO.readlines.join
    xenIO.close
    return report
  end

end
end
end
#TO CHECK 
#xl xentop
