class Cpu
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  store_in collection: "opstat.reports"
  index({timestamp: 1, host_id: 1, plugin_id: 1},{background: true})

  def self.chart_data(options = {})
    charts = []
    charts << self.cpu_chart(options)
    return charts
  end

  def self.cpu_chart(options)
    cpu_utilization = {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Cpu utilization in %',
			    :position => 'left',
			    :min_max_multiplier => 1,
			    :stack_type => '100%',
                            :include_guides_in_min_max => 'true',
			    :grid_alpha => 0.1
			  }
			],
               :graph_data => [],
	       :category_field => 'timestamp',
	       :graphs => [],
	       :title => "Host CPU usage",
	       :title_size => 20
	     }

    #CHOOSE HERE which
    # TODO ADD ALL TYPES
    graphs = {
      'system' =>  { :value_axis => 'valueAxis1', :line_color => "#FF0000", :balloon_text => "[[title]]: ([[percents]]%)", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line' },
      'nice' => { :line_color => '#FF3300' },
      'user' => { :line_color => '#FF7700' },
      'iowait' => { :line_color => '#FFaa00' },
      'irq' => { :line_color => '#FFdd00' },
      'softirq' => { :line_color => '#FFFF00' },
      'idle' => {:line_color => '#00FF00' }
    }
    prev = nil
    self.cpu_aggregate(options).each do |data|
      if prev.nil? then
        prev = data
        next
      end
      temp = {"timestamp" => data[:timestamp]}
      graphs.each_key {|g| temp[g] = data[g] - prev[g]}
      cpu_utilization[:graph_data] << temp
      prev = data
    end

    graphs.each_pair do |graph, properties|
      #TODO value_axis
      #TODO merge set values with default
      cpu_utilization[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :line_color => properties[:line_color],  :balloon_text => "[[title]]: ([[percents]]%)", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line', :title => graph}
    end
    cpu_utilization
  end

  def self.cpu_detailed(options)
  end

  def self.cpu_aggregate(options)
    #data = Cpu.where( { :timestamp => {:$gte => options[:start],:$lt => options[:end]} , :cpu_id => 'cpu', :host_id => options[:host_id], :plugin_id => options[:plugin_id]} ).order_by(timestamp: asc).all

    data = Cpu.where( :timestamp.gte => options[:start]).
               where( :timestamp.lt => options[:end]).
               where( :cpu_id => 'cpu').
	       where( :host_id => options[:host_id]).
	       where( :plugin_id => options[:plugin_id] ).order_by(timestamp: :asc)
    data
  end

  def self.graphs_defaults
   []
  end

  def self.axes_defaults
    []
  end
end
