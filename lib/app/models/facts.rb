class Facts
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!


  def self.chart_data(options = {})
    facter_data = {}
    p options
    self.where(:order => "timestamp desc", :conditions => [ 'timestamp >= ? and ip_address = ? and hostname = ?',options[:start], options[:ip_address], options[:hostname]]).order(:timetamp).all.each do |data|
      facter_data[data[:name]] ||= data[:value]
    end
    { :facter_data => facter_data }
  end
    
  def self.get_latest_facts_for_host(host_id)
    Facts.where( {:host_id => host_id, :plugin_type => 'facts'}).fields('facts').last
  end

  def self.legend
    @legend = {}
  end
end
Facts.ensure_index( [ [:timestamp, 1], [:host_id, 1] , [:plugin_id,1], [:plugin_type,1] ] )
Facts.ensure_index( [ [:host_id, 1] , [:plugin_id, 1]] )
