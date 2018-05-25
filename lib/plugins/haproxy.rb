require 'open-uri'
module Opstat
module Plugins

class Haproxy < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @haproxy_url = "#{config['url']}/;up/stats;csv;norefresh'"
    self
  end
    def parse
      report = []
      begin
        source = open(@haproxy_url,open_timeout: 1, read_timeout: 1).each do |line|
          report << line
        end
      rescue
        nil
      end
    return report
    end
  end
end
end 
