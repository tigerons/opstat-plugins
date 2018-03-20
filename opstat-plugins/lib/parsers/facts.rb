module Opstat
module Parsers
  # TODO - save changed only - is it possible?
  class Facts
    include Opstat::Logging

    def parse_data(data)
      [{ :facts => data }]
    end
  end
end
end
