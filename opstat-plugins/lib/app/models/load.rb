class Load
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts << self.load_chart(options)
    return charts
  end

  def self.load_chart(options)
    load_data = {
               :value_axes => [
                          { 
                            :name => "valueAxis1",
                            :title => 'Load average',
                            :position => 'left',
                            :min_max_multiplier => 1,
                            :stack_type => 'none',
                            :include_guides_in_min_max => 'false',
                            :grid_alpha => 0.1
                          }
                        ],
               :graph_data => [],
               :graphs => [],
               :title => "Host load average",
	       :category_field => 'time',
               :title_size => 20
             }

    #CHOOSE HERE which
    # TODO ADD ALL TYPES
    #TODO ADD GUIDES - if num of cores from facter
    graphs = [ :load_1m, :load_5m, :load_15m ]

#TODO cpu and here - sort by timestamp
    load_data[:graph_data] = Load.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).fields(:load_1m, :load_5m, :load_15m, :timestamp).order(:timetamp).all

    graphs.each do |graph|
      #TODO value_axis
      load_data[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0, :graph_type => 'line', :title => graph }
    end
    cores_total = Facts.get_fact({:name => "processorcount", :host_id => options[:host_id], :plugin_id => options[:plugin_id]})
    unless cores_total.nil?
      cores_total = cores_total.value.to_i
      #TODO - find best way to set guides
      # green zone - OK
      guides = [  {
        :value => 0,
        :to_value => cores_total,
        :value_axis => 'valueAxis1',
        :line_color => "#00FF00",
        :fill_color => "#00FF00",
        :line_thickness => 1,
        :dash_length => 5,
        :label => "",
        :inside => 'true',
        :line_alpha => 1,
        :fill_alpha => 0.1,
        :position => 'bottom'},
      # yellow zone - warn
        {:value => cores_total,
        :to_value => cores_total * 2,
        :value_axis => 'valueAxis1',
        :line_color => "#FFFF00",
        :fill_color => "#FFFF00",
        :line_thickness => 1,
        :dash_length => 5,
        :label => "",
        :inside => 'true',
        :line_alpha => 1,
        :fill_alpha => 0.1,
        :position => 'bottom'},
      # red zone - critical
        {:value => cores_total * 2,
        :to_value => cores_total * 100,
        :value_axis => 'valueAxis1',
        :line_color => "#FF0000",
        :fill_color => "#FF0000",
        :line_thickness => 1,
        :dash_length => 5,
        :label => "",
        :inside => 'true',
        :line_alpha => 1,
        :fill_alpha => 0.1,
        :position => 'bottom'}]
    end
    load_data[:guides] = guides
    load_data
  end
  
  def self.graphs_defaults
    [
     { :value_field => "Load_15m",
       :hidden => false,
       :line_color => "#FF0000",
       :line_thickness => 3,
       :title => "Load 15 minutes average"},
     { :value_field => "Load_5m",
       :hidden => false,
       :line_color => "#FFFF00",
       :line_thickness => 3,
       :title => "Load 5 minutes average"},
     { :value_field => "Load_1m",
       :hidden => false,
       :line_color => "#FFaa00",
       :line_thickness => 3,
       :title => "Load 1 minute average"}
    ]
  end

  def self.axes_defaults
    {
      :value_axis => {:title => 'System load average'}
    }
  end
end
Load.ensure_index( [ [:timestamp, 1], [:hostname, 1] , [:ip_address,1], [:cpus, 1] ] )
