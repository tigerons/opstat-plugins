require 'open-uri'
module Opstat
module Plugins

  class Haproxy < Task
    url = 'http://haproxy01-staging:1937/;up/stats;csv;norefresh' 
    def parse
      report = [] 
      source = open(url).each do |line|
	report << line 
      end 
    return report 
    end 
  end
end
end 
 
