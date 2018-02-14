class Facts
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, host_id: 1, plugin_id: 1, plugin_type: 1}, {background: true})
  index({host_id: 1, plugin_id: 1},{background: true})


  def self.chart_data(options = {})
    facter_data = {}
    self.where(:timestamp.gte => options[:start]).
         where(:ip_address => options[:ip_address]).
	 where(:hostname => options[:hostname]).order_by(timestamp: :asc).each do |data|
      facter_data[data[:name]] ||= data[:value]
    end
    { :facter_data => facter_data }
  end
    
  def self.get_latest_facts_for_host(host_id)
    Facts.where(:host_id => host_id)
          where(:plugin_type => 'facts').
	  last
  end

  def self.legend
    @legend = {}
  end
end
