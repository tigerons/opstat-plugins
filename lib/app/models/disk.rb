class Disk 
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts = self.all_disks_charts(options)
    return charts
  end

  def self.all_disks_charts(options)
    charts = []
    Disk.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).fields(:timestamp, :block_used, :block_free, :mount).order(:timetamp).all.group_by{|u| u.mount}.each_pair do |mount, values|
      charts << self.disk_chart(mount, values)
    end
    return charts
  end

  def self.disk_chart(mount, values)
    chart_data = {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Disk space usage for #{mount}',
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
	       :title => "Disk space usage for #{mount}",
	       :title_size => 20
	     }

    graphs = {
      :block_used => { :line_color => '#FF0000' },
      :block_free => {:line_color => '#00FF00' }
    }
    
    chart_data[:graph_data] = values

    graphs.each_pair do |graph, properties|
      #TODO value_axis
      #TODO merge set values with default
      ##TODO sort by timestamp
      chart_data[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :line_color => properties[:line_color],  :balloon_text => "[[title]]: ([[percents]]%)", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.1, :graph_type => 'line' }
    end
    chart_data
  end

  def self.graphs_defaults
    [
     { :value_field => "block_used",
       :hidden => false,
       :line_color => "#FF0000",
       :line_thickness => 3,
       :title => "block used"},
     { :value_field => "block_free",
       :hidden => false,
       :line_color => "#00FF00",
       :line_thickness => 3,
       :title => "block free"}
    ]
  end

  def self.axes_defaults
    {
      :value_axis => {:title => 'Number of blocks'}
    }
  end
end
Disk.ensure_index( [ [:timestamp, 1], [:host_id, 1] , [:plugin_id,1] ] )
