require 'csv'
module Opstat
module Parsers

        class Haproxy
         include Opstat::Logging

                def parse_data(data_parse)
                 csv_records = CSV.parse(data_parse.join, { headers: true, header_converters: :symbol, converters: :all })
                 @hashed_data = csv_records.map { |data| data.to_hash }.last

                end
         end
        end
end



