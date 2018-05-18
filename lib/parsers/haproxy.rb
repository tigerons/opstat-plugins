require 'csv'
module Opstat
module Parsers

  class Haproxy
    include Opstat::Logging

    def parse_data(data_parse)
      white_headers = [ :svname, :qcur, :qmax, :scur, :smax, :slim, :stot, :bin, :bout, :hrsp_1xx, :hrsp_2xx, :hrsp_3xx, :hrsp_4xx, :hrsp_5xx, :hrsp_other, :req_tot, :conn_tot]
      reports = {
        :frontends =>  [],
        :backends =>   []
      }

require 'pp'
  data = CSV.parse(data_parse, { headers: true, header_converters: :symbol, converters: :all}).map{|row| Hash[row.headers[0..-1].zip(row.fields[0..-1])]}.group_by{|row| row[:_pxname]}
  data.each { | key, value|
    case
      when value.first[:svname] == "FRONTEND"
        reports[:frontends] << { :name => value.first[:_pxname], :summary => value.first.select { |key, value| white_headers.include?(key)}}
      when value.first[:_pxname].to_s.start_with?("backend")
        backends = { :name => value.first[:_pxname] }
        rep = {}
        value.each do |backend|
          if backend[:svname].to_s.start_with?("BACKEND")
            backends[:summary] =  backend.select { |key, value| white_headers.include?(key)}
          else
            backend.map do |key, value|
              rep[key] = value
              backends[:details] =  rep.select { |key, value| white_headers.include?(key)}
            end
          end
            end
       nd
         reports[:backends] << backends
     }
  return reports
    end
end
end
end
