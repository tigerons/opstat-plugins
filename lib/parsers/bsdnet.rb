module Opstat
module Parsers
  class Bsdnet
    include Opstat::Logging

    def parse_data(data)
		  #TODO count num of interfaces - for now assuming only 1 interface
		  interface = data[2].split[3]
		  bytes_in_v4 = data[3].split[2].to_i
		  bytes_out_v4 = data[4].split[2].to_i
		  packets_passed_in_v4 = data[6].split[1].to_i
		  packets_blocked_in_v4 = data[7].split[1].to_i
		  packets_passed_out_v4 = data[9].split[1].to_i
		  packets_blocked_out_v4 = data[10].split[1].to_i
		  return [{
		    :interface => interface,
		    :bytes_in_v4 => bytes_in_v4,
		    :bytes_out_v4 => bytes_out_v4,
		    :packets_passed_in_v4 => packets_passed_in_v4,
		    :packets_blocked_in_v4 => packets_blocked_in_v4,
		    :packets_passed_out_v4 => packets_passed_out_v4,
		    :packets_blocked_out_v4 => packets_blocked_out_v4
		    }]
    end
  end
end
end
