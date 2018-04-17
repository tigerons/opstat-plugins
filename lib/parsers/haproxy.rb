require 'csv'
module Opstat
module Parsers

  class Haproxy
    include Opstat::Logging
    
    def parse_data(data_parse)
      white_headers = %w(svname bin bout)
      reports = []
       hashed_data = {}
      CSV.parse(data_parse, { headers: true, header_converters: :symbol, converters: :all}) do |row|
      hashed_data = Hash[row.headers[0..-1].zip(row.fields[0..-1])]
      reports <<  { 
	:_pxname => hashed_data[:_pxname],
	:svname =>  hashed_data[:svname],
	:qcur => hashed_data[:qcur],
	:qmax => hashed_data[:qmax],
	:scur => hashed_data[:scur],
	:smax => hashed_data[:smax],
	:slim => hashed_data[:slim],
	:stot => hashed_data[:stot],
	:bin => hashed_data[:bin],
	:bout => hashed_data[:bout]
       }
    end
      return reports
end
end 
end
end

