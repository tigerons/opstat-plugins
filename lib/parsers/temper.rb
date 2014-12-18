module Opstat
module Parsers
  require 'json'
  class Temper
    include Opstat::Logging

    def parse_data(data)
      #TODO - mesg when empty
      temperature = data.split(',')[1].to_f
      return [{
	    :temperature => temperature
      }]
    end
  end
end
end
