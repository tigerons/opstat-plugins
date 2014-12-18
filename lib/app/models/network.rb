class Network 
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  key :bytes_receive, Integer
  key :bytes_transmit, Integer
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts = self.all_interfaces_charts(options)
    return charts
  end

  def self.all_interfaces_charts(options)
    charts = []
    Network.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timetamp).all.group_by{|u| u.interface}.each_pair do |interface, values|
      charts << self.interface_chart(interface, values)
    end
    return charts
  end

  def self.interface_chart(interface, values)
    chart_data = {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Network traffic for #{interface}',
			    :position => 'left',
			    :min_max_multiplier => 1,
			    :stack_type => 'none',
                            :include_guides_in_min_max => 'true',
			    :grid_alpha => 0.1
			  }
			],
               :graph_data => [],
	       :category_field => 'timestamp',
	       :graphs => [],
	       :title => "Network traffic for #{interface}",
	       :title_size => 20
	     }

    graphs = {
      :bytes_receive_per_sec => { :line_color => '#0033FF' },
      :bytes_transmit_per_sec => {:line_color => '#00FF00' }
    }
    
    prev = nil
    values.each do |value|
      if prev.nil? then
        prev = value
        next
      end
      time_diff = value[:timestamp].to_i - prev[:timestamp].to_i
      chart_data[:graph_data] << {
        "timestamp" => value[:timestamp],
        "bytes_receive_per_sec" => ((value[:bytes_receive] - prev[:bytes_receive])/time_diff).to_i,
        "bytes_transmit_per_sec" => ((value[:bytes_transmit] - prev[:bytes_transmit])/time_diff).to_i
      }
      prev = value 
      
    end

    graphs.each_pair do |graph, properties|
      #TODO value_axis
      #TODO merge set values with default
      ##TODO sort by timestamp
      chart_data[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :line_color => properties[:line_color],  :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.1, :graph_type => 'line' }
    end
    chart_data
  end
  
  def self.graphs_defaults
    [
     { :value_field => "bytes_receive_per_sec",
       :hidden => false,
       :line_color => "#FF0000",
       :line_thickness => 3,
       :title => "Bytes received [B/s]"},
     { :value_field => "bytes_transmit_per_sec",
       :hidden => false,
       :line_color => "#00FF00",
       :line_thickness => 3,
       :title => "Bytes transmited [B/s]"}
    ]
  end

  def self.axes_defaults
    {
      :value_axis => {:title => 'Bytes per second'}
    }
  end
end
Network.ensure_index( [ [:timestamp, 1], [:host_id, 1] , [:plugin_id,1] ] )
