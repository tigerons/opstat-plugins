class OracleSessions
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts << self.sessions_chart(options)
    return charts
  end

  def self.sessions_chart(options)
    chart_data = {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Oracle sessions',
			    :position => 'left',
			    :min_max_multiplier => 1,
			    :stack_type => 'regular',
                            :include_guides_in_min_max => 'true',
			    :grid_alpha => 0.1
			  }
			],
               :graph_data => [],
	       :category_field => 'timestamp',
	       :graphs => [],
	       :title => "Oracle sessions",
	       :title_size => 20
	     }

    graphs = {
      :used => { :line_color => '#FF3300' },
      :free => {:line_color => '#00FF00' }
    }
    
    chart_data[:graph_data] = OracleSessions.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timetamp).all

    graphs.each_pair do |graph, properties|
      #TODO value_axis
      #TODO merge set values with default
      chart_data[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :line_color => properties[:line_color],  :balloon_text => "[[title]]: ([[percents]]%)", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line' }
    end
    chart_data
  end

  def self.graphs_defaults
    [
     { :value_field => "used",
       :hidden => false,
       :line_color => "#FF0000",
       :line_thickness => 3,
       :title => "Session used"},
     { :value_field => "free",
       :hidden => false,
       :line_color => "#00FF00",
       :line_thickness => 3,
       :title => "Sessions free"}
    ]
  end

  def self.axes_defaults
    {
      :value_axis => {:title => 'Sessions'}
    }
  end
end
