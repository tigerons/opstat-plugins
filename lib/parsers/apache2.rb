module Opstat
module Parsers
  require 'json'
  class Apache2 
    include Opstat::Logging
    
    def parse_data(data)
      return [] if data.nil?
      reports = []
      oplogger.debug data
      json_data = JSON::parse(data)
      json_data.each_pair do |vhost, stats|
        reports << { :vhost_name => vhost, :stats => stats }
      end
      return reports
    end
  end
end
end
