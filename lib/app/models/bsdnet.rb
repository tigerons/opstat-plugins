class Bsdnet
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    options[:interface] = 'vlan254'
    charts << self.bytes_chart(options)
    #TODO interfaces??
    return charts
  end

  def self.bytes_chart(options)
    chart_data = {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Network traffic [Bytes]',
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
	       :title => "Network traffic in/out",
	       :title_size => 20
	     }

    graphs = {
      :bytes_in => { :line_color => '#FF3300' },
      :bytes_out => {:line_color => '#00FF00' }
    }
    
    #TODO - sort by date
    datas = Bsdnet.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timetamp).all
    prev = nil
    datas.each do |data|
      if prev.nil?
        prev = data
        next
      end
      bytes_in_per_sec = (data[:bytes_in_v4] - prev[:bytes_in_v4])/(data[:timestamp] - prev[:timestamp])
      bytes_out_per_sec = (data[:bytes_out_v4] - prev[:bytes_out_v4])/(data[:timestamp] - prev[:timestamp])
      chart_data[:graph_data] << {
        :timestamp => data[:timestamp],
        :bytes_out => bytes_out_per_sec.to_i,
        :bytes_in => bytes_in_per_sec.to_i
      }
      prev = data
    end

    graphs.each_pair do |graph, properties|
      #TODO value_axis
      #TODO merge set values with default
      chart_data[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :line_color => properties[:line_color],  :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.2, :graph_type => 'line' }
    end
    chart_data
  end

  
  def self.axes_defaults
    {
      :value_axis => {:title => 'Transfer in bytes/s'}
    }
  end

  def self.graphs_defaults
    { "bytes_in" => true, "bytes_out" => true }
  end
end
