module Opstat
module Parsers
  class Network
    include Opstat::Logging

    def parse_data(data)
      reports = []
      interfaces_stats = data[2..-1].map{|u| u.lstrip}.join.split("\n")
      interfaces_stats.each do |interface_stat|
	interface, values = interface_stat.split(':')
	next if values.nil?
        v = values.split
        reports << {
          :interface => interface,
	  :bytes_receive => v[0].to_i,
	  :packets_receive => v[1].to_i,
	  :errors_receive => v[2].to_i,
	  :drop_receive => v[3].to_i,
	  :fifo_receive => v[4].to_i,
	  :frame_receive => v[5].to_i,
	  :compressed_receive => v[6].to_i,
	  :multicast_receive => v[7].to_i,
	  :bytes_transmit => v[8].to_i,
	  :packets_transmit => v[9].to_i,
	  :errors_transmit => v[10].to_i,
	  :drop_transmit => v[11].to_i,
	  :fifo_transmit => v[12].to_i,
	  :frame_transmit => v[13].to_i,
	  :compressed_transmit => v[14].to_i,
	  :multicast_transmit => v[15].to_i
        }
      end
      return reports
    end
  end
end
end
