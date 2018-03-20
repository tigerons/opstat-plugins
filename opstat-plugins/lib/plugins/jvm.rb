module Opstat
module Plugins
class Jvm < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @snmp_host = config['snmp_host']
    @snmp_port = config['snmp_port']
    @snmp_cmd = "snmpget -c public -v2c #{@snmp_host}:#{@snmp_port} 1.3.6.1.4.1.42.2.145.3.163.1.1.3.1.0 1.3.6.1.4.1.42.2.145.3.163.1.1.3.2.0 1.3.6.1.4.1.42.2.145.3.163.1.1.3.3.0|cut -f2 -d="
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
