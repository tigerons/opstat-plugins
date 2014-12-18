module Opstat
module Parsers
  class OracleFrasSizes
    include Opstat::Logging

  #TODO - somehow check plugins version
    def parse_data(data)
      reports = []
      data.split("\n")[3..-1].each do |line|
	  tablespace = line.split(/\s+/).delete_if{|t| t.empty?}
          total = tablespace[1].to_i
          used = tablespace[2].to_i
	  free = total - used
          reports << {
            :path => tablespace[0],
            :free => free,
            :used => used,
            :files => tablespace[3].to_i
	  }
      end
      return reports
    end
  end
end
end
