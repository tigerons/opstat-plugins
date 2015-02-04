module Opstat
module Parsers
  class Jvm
    include Opstat::Logging

    def parse_data(data)
      return if data.nil? #TODO EVENT IN db
      
      begin
      data.split("\n").each do |line|
        oplogger.debug "parsing line #{line}"
      end
      rescue
	#TODO find best way to deal with that kind of problems
	#TODO check if timestamp > prev
        return
      end
      return report
    end
  end
end
end
