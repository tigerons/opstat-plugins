module Opstat
module Parsers
  class DiskIo
    include Opstat::Logging

    def parse_data(data)
      data.find{|a| a =~ /^(?<major_number>\S+)\s+(?<minor_number>\S+)\s+(?<device_name>\S+)\s+(?<reads_completed>\d+)\/(?<reads_merged>\d+)\s+(?<sector_read>\d+)\s+(?<time_spent_reading_ms>\d+)\s+(?<writes_completed>\d+)\s+(?<writes_merged>\d+)\s+(?<sectors_written>\d+)\s+(?<time_spent_writing>\d+)\s+(?<io_in_progress>\d+)\s+(?<time_spent_doing_io_ms>\d+)\s+(?<weighted_time_doing_io>\d+)\s+.*/}
      p $~
      return [{
      # :load_1m => $~[:load_1m].to_f,
#       :load_5m => $~[:load_5m].to_f,
#       :load_15m => $~[:load_15m].to_f,
#       :threads_running => $~[:threads_running].to_i,
#       :threads => $~[:threads].to_i
     }]
    end
  end
end
end
