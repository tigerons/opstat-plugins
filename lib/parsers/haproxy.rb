require 'csv'
module Opstat
module Parsers

  class Haproxy
    include Opstat::Logging

    def parse_data(data_parse)
      p data_parse
      white_headers = [:_pxname, :svname, :qcur, :qmax, :scur, :smax, :slim, :stot, :bin, :bout, :hrsp_1xx, :hrsp_2xx, :hrsp_3xx, :hrsp_4xx, :hrsp_5xx, :hrsp_other, :req_tot, :conn_tot]
      hashed_data = {}
      reports = []
      data_parse.split.each do |word|
      CSV.parse(word.join, { headers: true, header_converters: :symbol, converters: :all}) do |row|
      hashed_data = Hash[row.headers[0..-1].zip(row.fields[0..-1])]
      reports <<  hashed_data.select {|key, value| white_headers.include?(key) }
      end
      end
      return reports
    end
  end
end
end

