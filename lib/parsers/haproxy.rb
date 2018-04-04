require 'csv'
module Opstat
module Parsers

  class Haproxy
    include Opstat::Logging
  
    def parse_data(data_parse)
      csv_records = CSV.parse(data_parse.join, { headers: true, header_converters: :symbol, converters: :all })
	
      @hashed_data = csv_records.map { |data| data.to_hash }
      begin
	return [{
	  :pxname => @hashed_data[:pxname],
	  :svname => @hashed_data[:svname],
	  :qcur => @hashed_data[:qcur],
	  :qmax => @hashed_data[:qmax],
	  :scur => @hashed_data[:scur],
	  :smax => @hashed_data[:smax],
	  :slim => @hashed_data[:slim],
	  :stot => @hashed_data[:stot],
	  :status => @hashed_data[:status],
	  :bin => @hashed_data[:bin],
	  :bout => @hashed_data[:bout],
	}] 
      rescue Exception => e
	return [] 
      end  
    end
end
end 
end 






