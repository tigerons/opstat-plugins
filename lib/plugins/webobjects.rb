module Opstat
module Plugins
class Webobjects < Task
  attr_accessor :interval

  def initialize (name, queue, config)
    super(name, queue, config)
    @wotask_password = config['wotask_password']
    @wotask_url = config['wotask_url']
    self
  end

  def parse
    report = []
    @curl_cmd ||= '/usr/bin/curl --header \'password: ' + @wotask_password + '\' --data \'<monitorRequest type="NSDictionary"><queryWotaskd type="NSString">INSTANCE</queryWotaskd></monitorRequest>\' ' + @wotask_url  + ' 2>/dev/null'
    xmlIO = IO.popen(@curl_cmd)
    report  = xmlIO.readlines.join
    xmlIO.close
    return report
  end

end
end
end

#NEEDED - curl, xml-simple
