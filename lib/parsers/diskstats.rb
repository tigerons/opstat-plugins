require 'yaml'

module Opstat
module Parsers
  class Diskstats
    include Opstat::Logging

    def parse_data(data)
      reports = []
      oplogger.debug data
      data.each do |line|
        stats = line.split
	if stats[0].to_i != 7 #loop device
          reports << {
            :device => stats[2],
	    :reads_completed => stats[3].to_i,
            :reads_merged => stats[4].to_i,
            :reads_sectors => stats[5].to_i,
	    :time_spent_reading => stats[6].to_i,
	    :writes_completed => stats[7].to_i,
            :writes_merged => stats[8].to_i,
            :writes_sectors => stats[9].to_i,
	    :time_spent_writing => stats[10].to_i,
	    :io_in_progress => stats[11].to_i,
	    :time_spent_on_io => stats[12].to_i,
	    :weghted_time_spent_on_io => stats[13].to_i,
          }
        end
      end
      return reports
    end
  end
end
end
