module Opstat
module Parsers
  class DiskIo
    include Opstat::Logging

    def parse_data(data)
      report = []
      data.each do |line|
        line.match(/^\s+(?<major_number>\d+)\s+(?<minor_number>\d+)\s+(?<device_name>\S+)\s+(?<reads_completed>\d+)\s+(?<reads_merged>\d+)\s+(?<sector_read>\d+)\s+(?<time_spent_reading_ms>\d+)\s+(?<writes_completed>\d+)\s+(?<writes_merged>\d+)\s+(?<sectors_written>\d+)\s+(?<time_spent_writing>\d+)\s+(?<io_in_progress>\d+)\s+(?<time_spent_doing_io_ms>\d+)\s+(?<weighted_time_doing_io>\d+)\s+.*/)
        report << Hash[*$~.names.zip($~.captures).flatten]
      end
      return report
    end
  end
end
end

