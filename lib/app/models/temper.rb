class Temper
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts << self.temper_chart(options)
    return charts
  end
  
  def self.temper_chart(options)
    data = {
               :value_axes => [
                          { 
                            :name => "valueAxis1",
			    :title => 'Temperature in [C]',
                            :position => 'left',
                            :min_max_multiplier => 1,
			    :stack_type => 'regular',
                            :include_guides_in_min_max => 'true',
			    :grid_alpha => 0.07
                          }
                        ],
	       :guides => [],
               :graph_data => [],
               :graphs => [],
	       :title => "Temperature",
	       :category_field => 'timestamp',
               :title_size => 20
             }

    graphs = [:temperature]

    #TODO - get fields from above DRY
    data[:graph_data] = Temper.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timetamp).all
    graphs.each do |graph|
      data[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line' }
    end
    data
  end

  def self.axes_defaults
    {
      :value_axis => {:title => 'Temperature in C'}
    }
  end

  def self.graphs_defaults
    [
     { :value_field => "Temperature",
       :hidden => false,
       :line_color => "#FF0000",
       :title => "Temperature"}
    ]
  end
end
