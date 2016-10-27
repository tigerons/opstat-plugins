module Opstat
module Parsers
  class Cpu
    include Opstat::Logging

    def parse_data(data)
      reports = []
      data.each do |line|
        if line =~ /(?<cpu_id>\S+)\s+(?<user>\d+)\s+(?<nice>\d+)\s+(?<system>\d+)\s+(?<idle>\d+)\s+(?<iowait>\d+)\s+(?<irq>\d+)\s+(?<softirq>\d+).*/
          reports << {
	    :cpu_id => $~[:cpu_id],
            :user => $~[:user].to_i,
            :nice => $~[:nice].to_i,
            :system => $~[:system].to_i,
            :idle => $~[:idle].to_i,
            :iowait => $~[:iowait].to_i,
            :irq => $~[:irq].to_i,
            :softirq => $~[:softirq].to_i
	  }
        end
      end
      return reports
    end
  end
end
end
