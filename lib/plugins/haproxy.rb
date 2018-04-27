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
      source = open(@haproxy_url).each do |line|
      report << line 
    end 
     return report 
    end 
  end
end
end 
