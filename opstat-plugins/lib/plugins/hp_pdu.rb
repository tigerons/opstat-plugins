require 'yaml'
module Opstat
module Plugins
class HpPdu < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @snmp_host = config['snmp_host']
    @snmp_port = config['snmp_port']
    pwd  = File.dirname(File.expand_path(__FILE__))
    snmp_ids = YAML::load_file("#{pwd}/../data/hp_pdu.yml").keys.join(' ')
    @snmp_cmd = "snmpget -c public -v2c #{@snmp_host}:#{@snmp_port} #{snmp_ids}"
  end

  def parse
    snmpIO = IO.popen(@snmp_cmd)
    report  = snmpIO.readlines.join
    snmpIO.close
    return report
  end

end
end
end


#for test
# check snmp is installed
# check port is open - snmp is accessible
