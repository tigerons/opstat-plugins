module Opstat
module Parsers
  class Network
    include Opstat::Logging

    def parse_data(data)
      reports = []
      interfaces_stats = data[2..-1].map{|u| u.lstrip}.join.split("\n")
      interfaces_stats.each do |interface_stat|
	interface, values = interface_stat.split(':')
        v = values.split
        reports << {
          :interface => interface,
	  :bytes_receive => v[0],
	  :packets_receive => v[1],
	  :errors_receive => v[2],
	  :drop_receive => v[3],
	  :fifo_receive => v[4],
	  :frame_receive => v[5],
	  :compressed_receive => v[6],
	  :multicast_receive => v[7],
	  :bytes_transmit => v[8],
	  :packets_transmit => v[9],
	  :errors_transmit => v[10],
	  :drop_transmit => v[11],
	  :fifo_transmit => v[12],
	  :frame_transmit => v[13],
	  :compressed_transmit => v[14],
	  :multicast_transmit => v[15]
        }
      end
      return reports
    end
  end
end
end
