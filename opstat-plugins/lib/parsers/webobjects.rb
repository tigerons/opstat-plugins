require 'xmlsimple'

module Opstat
module Parsers
  class Webobjects
    include Opstat::Logging

    def parse_data(data)
      oplogger.debug data
      return if data.length == 0
      reports = []
      ref  = XmlSimple.xml_in(data, {'KeyAttr'    => { 'instanceResponse' => 'type' }, 'ForceArray' => [ 'type' ],'ContentKey' => '-content'})

      ref["queryWotaskdResponse"]["instanceResponse"]["element"].find_all{|instance| instance["runningState"]["content"] == "ALIVE"}.each do |instance|
	oplogger.debug instance
        id = instance["id"]["content"]
        application_name = instance["applicationName"]["content"]
	begin
          sessions = instance['statistics']['activeSessions']['content']
          transactions = instance['statistics']['transactions']['content']
	rescue
	  #TODO why next?
	  next
	end
        reports << {
		    :instance => id.to_i,
		    :application_name => application_name,
		    :sessions => sessions.to_i,
		    :transactions => transactions.to_i
		    }
      end
      return reports
    end
  end
end
end
