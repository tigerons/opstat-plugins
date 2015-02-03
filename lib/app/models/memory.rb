class Memory
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts << self.memory_chart(options)
    return charts
  end
  
  def self.memory_chart(options)
    memory_data = {
               :value_axes => [
                          { 
                            :name => "valueAxis1",
			    :title => 'Memory size in KB',
                            :position => 'left',
                            :min_max_multiplier => 1,
			    :stack_type => 'regular',
                            :include_guides_in_min_max => 'true',
			    :grid_alpha => 0.07
                          }
                        ],
               :graph_data => [],
               :graphs => [],
	       :title => "Host memory usage",
	       :category_field => 'timestamp',
               :title_size => 20
             }

    graphs = [:used, :cached, :buffers, :free, :swap_used]

    #TODO - get fields from above DRY
    memory_data[:graph_data] = Memory.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).fields(:used, :cached, :buffers, :swap_used, :free, :timestamp).order(:timetamp).all
    graphs.each do |graph|
      memory_data[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line' }
    end

    guides = []
    memory_total = Facts.get_fact({:name => "memorytotal", :host_id => options[:host_id]})
    unless memory_total.nil?
      guide = {}
      require 'ruby-units'
      #TODO Temporary workaround - change plugin data units from KiB to B
      memory_in_si = memory_total.value.sub("GB","GiB").sub("MB","MiB")
      guide[:value] = Unit(memory_in_si).to('KiB').scalar
      guide[:value_axis] = 'valueAxis1'
      guide[:line_color] = "#FF0000"
      guide[:line_thickness] = 1
      guide[:dash_length] = 5
      guide[:label] = "Total physical memory: #{memory_in_si} (by facter)"
      guide[:inside] = 'true'
      guide[:line_alpha] = 1
      guide[:position] = 'bottom'
      guides << guide
    end
    memory_data[:guides] = guides
    memory_data
  end

  def self.graphs_defaults
    { "Used" => true, "Buffers" => true, "Cached" => true, "SwapUsed" => true }
  end

  def self.axes_defaults
    {
      :value_axis => {:title => 'Memory size'}
    }
  end
end

Memory.ensure_index( [ [:timestamp, 1], [:host_id, 1] , [:plugin_id,1] ] )
