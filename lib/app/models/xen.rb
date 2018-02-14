class Xen
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaNotStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime


  def self.chart_data(options = {})
    charts = []

    charts << self.memory_chart(options)
  end
  
  def self.vbd_chart(options)
    memory = {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Memory in KB',
			    :position => 'left',
			    :stack_type => 'regular',
			    :grid_alpha => 0.07,
			    :min_max_multiplier => 1,
                            :include_guides_in_min_max => 'true'
			  }
			],
	       :category_field => 'timestamp',
               :graph_data => [],
	       :graphs => [],
	       :title => "XEN memory usage",
	       :title_size => 20
	     }
    graphs = []
    # TODO - why use periods in this query
    Xen.where(:timestamp.gte => options[:start]).
        where(:timestamp.lt => options[:end]).
	where(:ip_address => options[:ip_address]).
	where(:hostname => options[:hostname]).
	group('UNIX_TIMESTAMP(timestamp) div 60, domain').
	order_by(:timestamp).select('FROM_UNIXTIME((UNIX_TIMESTAMP(timestamp) div 60) *60,\'%Y-%m-%d %H:%i:%S\') as period_start, domain,max(memory) as memory').group_by{|u| u.period_start}.each_pair do |period_start, domains|
     tmp = { :year => period_start.to_datetime.to_i * 1000 }
     #TODO sort
     domains.each do |domain|
       tmp[domain.domain] = domain.memory
       graphs << domain.domain  unless graphs.include?(domain.domain)
     end
     memory[:graph_data] << tmp
   end
    graphs.each do |graph|
      #TODO value_axis
      memory[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: [[value]] KB", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 1, :graph_type => 'line' }
    end
    memory
  end
  def self.memory_chart(options)
    memory = {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Memory in KB',
			    :position => 'left',
			    :stack_type => 'regular',
			    :grid_alpha => 0.07,
			    :min_max_multiplier => 1,
                            :include_guides_in_min_max => 'true'
			  }
			],
	       :category_field => 'timestamp',
               :graph_data => [],
	       :graphs => [],
	       :title => "XEN memory usage",
	       :title_size => 20
	     }
    graphs = []
    all_stats = Xen.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timestamp).group_by{|u| u.domain}
    tmp = {}
    Xen.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timestamp).group_by{|u| u.domain}.each_pair do |domain,stats|
      stats.each do |stat|
        tmp[stat['timestamp']] ||= { 'timestamp' => stat['timestamp'] }
        tmp[stat['timestamp']] = tmp[stat['timestamp']].merge!({ stat['domain'] => stat['memory']})
      end
    end
    memory[:graph_data] = tmp.values
    all_stats.keys.each do |domain|
      memory[:graphs] << { :value_axis => 'valueAxis1', :value_field => domain, :balloon_text => "[[title]]: [[value]] KB", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 1, :graph_type => 'line' }
    end
    memory
  end

  def self.graphs_defaults
   []
  end

  def self.axes_defaults
    []
  end
end
