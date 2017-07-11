module Opstat
module Plugins
class Webobjects < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    @wotask_password = config['wotask_password']
    @wotask_url = config['wotask_url']
    @wotask_type = config['wotask_type']
    @wotask_name = config['wotask_name']
    self
  end

  def parse
    report = []
    curl_cmd ||= '/usr/bin/curl \'' +  @wotask_url + '?pw=' + @wotask_password + '&type=' + @wotask_type + '&name=' + @wotask_name + '\'' + ' 2>/dev/null'
    output_io = IO.popen(curl_cmd)
    report  = output_io.readlines.join
    output_io.close
    return report
  end
  
  def default_config
    {
      interval: 60
      wotask_password: jm_password
      wotask_url: "http://127.0.0.1:666/cgi-bin/WebObjects/JavaMonitor.woa/admin/info"
      wotask_type: all
      wotask_name: app_or_instance_name
    }
  end

end
end
end

#NEEDED - curl
