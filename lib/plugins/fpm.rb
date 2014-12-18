pstat
module Plugins
class Fpm < Task
  require 'json'
  attr_accessor :interval

  def initialize (name, queue, config)
    super(name, queue, config)
    @pools = config['pools']
    self
  end

  def parse
    report = []
    @pools.each_pair do |pool,options|
      logger.debug "getting #{pool} statistics"
      env = {"REQUEST_METHOD" => options['request_method'], "SCRIPT_NAME" => options['status_url'], "SCRIPT_FILENAME" => options['status_url'], "QUERY_STRING" => 'json'}
      logger.debug "cgi-fcgi environment: #{env.inspect}"
      fpmIO = IO.popen([env, 'cgi-fcgi','-bind','-connect',options['fcgi_socket'] ])
      pool_report  = fpmIO.readlines
      logger.debug "#{pool} statistics: #{pool_report}"
      report << pool_report
      fpmIO.close
    end
    return report
  end

end
end
end
#TO CHECK -cgi-fcgi installed
#- pm.status_path  property set in pool configuration


