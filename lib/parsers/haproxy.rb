  1 require 'csv'
  2 module Opstat
  3 module Parsers
  4 
  5   class Haproxy
  6     include Opstat::Logging
  7 
  8     def parse_data(data_parse)
  9       white_headers = [ :svname, :qcur, :qmax, :scur, :smax, :slim, :stot, :bin, :bout, :hrsp_1xx, :hrsp_2xx, :hrsp_3xx, :hrsp_4xx, :hrsp_5xx, :hrsp_other, :req_tot    , :conn_tot]
 10       hashed_data = {}
 11       reports = []
 12       frontends = {}
 13       reports_backends = []
 14       reports_frontends = []
 15       reports_summary_backends = []
 16       backends = {}
 17 
 18       CSV.parse(data_parse, { headers: true, header_converters: :symbol, converters: :all}) do |row|
 19         hashed_data = [Hash[row.headers[0..-1].zip(row.fields[0..-1])]]
 20 
 21         hashed_data.select { |hash| hash[:svname] == "FRONTEND" }.each do |frontend_instances|
 22           frontends[:frontends] =  { :name => frontend_instances[:_pxname], :summary => frontend_instances.select { |key, value| white_headers.include?(key) }}
 23         end
 24 
 25           hashed_data.select { |hash| hash[:svname] == "BACKEND" }.each do |backend_summary|
 26             backends[:backends] = { :name => backend_summary[:_pxname], :summary => backend_summary.select { |key, value| white_headers.include?(key) }}
 27 end

 29 end
 30 return frontends.merge(backends)
 31 end
 32 end
 33 end
 34 end

