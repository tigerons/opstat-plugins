module Opstat
module Parsers
  class OracleTablespacesSizes
    include Opstat::Logging

  #TODO - somehow check plugins version
    def parse_data(data)
      reports = []
      data.split("\n")[3..-3].each do |line|
	  tablespace = line.split(/\s+/).delete_if{|t| t.empty?}
          reports << {
            :name => tablespace[0],
            :total => tablespace[1].to_i,
            :used => tablespace[2].to_i,
            :free => tablespace[3].to_i
	  }
      end
      return reports
    end
  end
end
end
