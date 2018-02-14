class Jvm
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaNotStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime

  def self.chart_data(options = {})
    charts = []

    charts << self.threads_chart(options)
  end
  
  def self.threads_chart(options)
    graphs = [:free, :swap_used]
    graph_fields = graphs << :timestamp
    chart = area_stacked_chart(:graphs => graphs, :value_axis_title => 'Number of threads', :chart_title => 'Java threads')
    chart[:graph_data] = Jvm.where(:timestamp.gte => options[:start]).
                             where(:timestamp.lt => options[:end]).
			     where(:host_id => options[:host_id]).
			     where(:plugin_id => options[:plugin_id]).
			     order_by(timestamp: :asc)
    return chart
  end
end

def area_stacked_chart(config)
  chart = {
           :value_axes => [
             {     
	       :name => "valueAxis1",
	       :title => config[:value_axis1_title],
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
	   :title => config[:chart_title],
	   :title_size => 20
	} 
  config[:graphs].each do |graph|
    chart[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line' }
  end
  return chart
end
