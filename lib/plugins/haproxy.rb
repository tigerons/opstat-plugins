require 'open-uri'
module Opstat
module Plugins
class Haproxy < Task

  def data   
   url = 'http://haproxy01-staging:1937/;up/stats;csv;norefresh'
   source = open(url).read
  end

end
end 
end 
 

 




