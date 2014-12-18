module Opstat
module Parsers
  class Load
    include Opstat::Logging

    def parse_data(data)
      data.find{|a| a =~ /^(?<load_1m>\S+)\s+(?<load_5m>\S+)\s+(?<load_15m>\S+)\s+(?<threads_running>\d+)\/(?<threads>\d+).*/}
      return [{
       :load_1m => $~[:load_1m].to_f,
       :load_5m => $~[:load_5m].to_f,
       :load_15m => $~[:load_15m].to_f,
       :threads_running => $~[:threads_running].to_i,
       :threads => $~[:threads].to_i
     }]
    end
  end
end
end
