  1 require 'csv'
  2 module Opstat
  3 module Parsers
  4 
  5   class Haproxy
  6     include Opstat::Logging
  7 
  8     def parse_data(data_parse)
  9       white_headers = [ :svname, :qcur, :qmax, :scur, :smax, :slim, :stot, :bin, :bout, :hrsp_1xx, :hrsp_2xx, :hrsp_3xx, :hrsp_4xx, :hrsp_5xx, :hrsp_other, :req_tot, :conn_tot]
 10       reports = {
 11         :frontends =>  [],
 12         :backends =>   []
 13       }
 16     data = CSV.parse(data_parse, { headers: true, header_converters: :symbol, converters: :all}).map{|row| Hash[row.headers[0..-1].zip(row.fields[0..-1])]}.group_by{|row| row[:_pxname]}
 17     data.each { | key, value|
 18       case
 19         when value.first[:svname] == "FRONTEND"
 20           reports[:frontends] << { :name => value.first[:_pxname], :summary => value.first.select { |key, value| white_headers.include?(key)}}
 21         when value.first[:_pxname].to_s.start_with?("backend")
 22           backends = { :name => value.first[:_pxname] }
 23           rep = []
 24           value.each do |backend|
 25             if backend[:svname].to_s.start_with?("BACKEND")
 26               backends[:summary] =  backend.select { |key, value| white_headers.include?(key)}
 27             else
 28               backends[:details] = value.first.select { |key, value| white_headers.include?(key)}
 29             end
 30     reports[:backends] << backends
 32             end
 33           end
 34          } 
 35     return reports
 36     end
 37 end 
 38 end 
 39 end 
 40  
 41  

