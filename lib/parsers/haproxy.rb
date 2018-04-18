require 'csv'
module Opstat
module Parsers

  class Haproxy
    include Opstat::Logging
    
    def parse_data(data_parse)
      white_headers = [:_pxname, :svname, :qcur, :qmax, :scur, :smax, :slim, :stot, :bin, :bout]
      hashed_data = {} 
      reports = [] 
      CSV.parse(data_parse, { headers: true, header_converters: :symbol, converters: :all}) do |row|
	hashed_data = Hash[row.headers[0..-1].zip(row.fields[0..-1])]
      end 
      reports = hashed_data.select {|key, value| white_headers.include?(key) } 
      return reports 
    end 
  end
end
end 
 
