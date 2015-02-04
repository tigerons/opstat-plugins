module Opstat
module Parsers
  class HpPdu
    include Opstat::Logging

    def snmp_ids
      @snmp_ids ||= YAML::load_file("#{File.dirname(File.expand_path(__FILE__))}/../data/hp_pdu.yml")
      @snmp_ids
    end

    def parse_data(data)
      return if data.nil? #TODO EVENT IN db
      temp = {}
      begin
      ids = data.split("\n")
      ids.each do |id|
        k, v = id.split(' = ')
	if self.snmp_ids.has_key?(k)
	  props = snmp_ids[k]
	  temp_key = "#{props[:meter_type]}#{props[:pdu]}"
	  temp[temp_key] ||= {:meter_type => props[:meter_type], :pdu => props[:pdu]}
	  temp[temp_key][props[:store_key]] = v.split(': ')[-1].to_i
	end
      end

      rescue
	#TODO find best way to deal with that kind of problems
	#TODO check if timestamp > prev
        return
      end
      reports = temp.values
      return  reports
    end
  end
end
end
