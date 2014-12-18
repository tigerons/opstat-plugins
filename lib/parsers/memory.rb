require 'yaml'

module Opstat
module Parsers
  class Memory
    include Opstat::Logging

    def parse_data(data)
      memory = YAML::load(data.join)
      oplogger.debug memory
      return [{
        :total => memory["MemTotal"].split[0].to_i,
        :free => memory["MemFree"].split[0].to_i,
        :used => memory["MemTotal"].split[0].to_i - memory["MemFree"].split[0].to_i - memory["Cached"].to_i - memory["Buffers"].to_i,
        :cached => memory["Cached"].split[0].to_i,
        :buffers => memory["Buffers"].split[0].to_i,
        :swap_total => memory["SwapTotal"].split[0].to_i,
        :swap_free => memory["SwapFree"].split[0].to_i,
        :swap_used => memory["SwapTotal"].split[0].to_i - memory["SwapFree"].split[0].to_i
      }]
    end
  end
end
end
