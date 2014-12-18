class Nagios
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts << self.nagios_chart(options)
    return charts
  end
  
  def self.nagios_chart(options)
    data = {
               :value_axes => [
                          { 
                            :name => "valueAxis1",
			    :title => 'Nagios problem counter',
                            :position => 'left',
                            :min_max_multiplier => 1,
			    :stack_type => 'regular',
                            :include_guides_in_min_max => 'true',
			    :grid_alpha => 0.07
                          }
                        ],
               :graph_data => [],
               :graphs => [],
	       :title => "Nagios alerts statistic",
	       :category_field => 'timestamp',
               :title_size => 20
             }

    graphs = [:services_critical, :services_warning, :services_unknown, :services_ok]

    #TODO - get fields from above DRY
    data[:graph_data] = Nagios.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).fields(:services_critical, :services_warning, :services_unknown, :services_ok, :timestamp).order(:timetamp).all
    graphs.each do |graph|
      data[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line' }
    end
    data
  end
  
  def self.axes_defaults
    {
      :value_axis => {:title => 'Number of checks'}
    }
  end

  def self.graphs_defaults
    [
     { :value_field => "Services Critical",
       :hidden => false,
       :line_color => "#FF0000",
       :title => "Services with critical errors"},
     { :value_field => "Services Warning",
       :hidden => false,
       :line_color => "#FFFF00",
       :title => "Services with warnings"},
     { :value_field => "Services Unknown",
       :hidden => false,
       :line_color => "#FFaa00",
       :title => "Services in unknown state"},
     { :value_field => "Services OK",
       :hidden => true,
       :line_color => "#00FF00",
       :title => "Services with no problems"}
    ]
  end
end
