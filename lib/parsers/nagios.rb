module Opstat
module Parsers
  class Nagios
    include Opstat::Logging

    def parse_data(data)
      report = {}
      begin
        data.compact.each do |elem|
          v = elem.strip.split(':')
	  next if  v.length == 0
	  next if v.count != 2
	  key = v[0].strip
	  val = v[1].strip
	  report[key] = val
        end
      rescue
      #TODO add errors to gui - bad data
        return
      end
      report["Hosts Up"], report["Hosts Down"], report["Hosts Unreachable"] = report["Hosts Up/Down/Unreach"].split('/')
      report["Services Ok"], report["Services Warning"], report["Services Unknown"], report["Services Critical"] = report["Services Ok/Warn/Unk/Crit"].split('/')
      return [{
            :services_total => report["Total Services"],
            :hosts_total => report["Total Hosts"],
            :services_checked => report["Services Checked"],
            :hosts_checked => report["Hosts Checked"],
            :services_ok => report["Services Ok"],
            :services_warning => report["Services Warning"],
            :services_critical => report["Services Critical"],
            :services_unknown => report["Services Unknown"],
            :hosts_up => report["Hosts Up"],
            :hosts_down => report["Hosts Down"],
	    :hosts_unreachable => report ["Hosts Unreachable"]
      }]
    end
  end
end
end
