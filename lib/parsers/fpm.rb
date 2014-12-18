module Opstat
module Parsers
  class Fpm
    require 'json'
    include Opstat::Logging

    def parse_data(data)
      begin
        return [] if data.nil?
	reports = []
        data.each do |pool_stats|
          values = JSON::parse(pool_stats[-1])
          reports << {
	    :pool => values['pool'],
	    :accepted_connections => values['accepted conn'],
	    :listen_queue => values['listen queue'],
	    :listen_queue_length => values['listen queue len'],
	    :listen_queue_max => values['max listen queue'],
	    :processes_idle => values['idle processes'],
	    :processes_active => values['active processes'],
	    :processes_active_max => values['max active processes'],
	    :children_max => values['max children reached']
          }
        end
      end
	#TODO - set some error message in db
      return reports
    end
  end
end
end
