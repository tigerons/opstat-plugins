require 'open-uri'
require 'csv'
module Opstat
module Parsers

	class Haproxy
 	 include Opstat::Logging

		def parse_data(data)
 
                 source = File.read('/home/tajger/Dokumenty/opstat-plugins/haproxy_stat.txt')          
		 csv_records = CSV.parse(source, { headers: true, header_converters: :symbol, converters: :all })
		 @hashed_data = csv_records.map { |data| data.to_hash }.last

		end 
 

	 end 
        end
end
 




