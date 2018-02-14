class Load
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::LineChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, hostname: 1, ip_address: 1},{background: true})

  def self.chart_data(options)
    charts = []
    charts << self.load_chart(options)
    return charts
  end

  def self.load_chart(options)
    chart = self.chart_structure({:title => "Host load average", :value_axis => { :title => "Load averages"}, :include_guides_in_min_max => false})

    #CHOOSE HERE which
    # TODO ADD ALL TYPES
    #TODO ADD GUIDES - if num of cores from facter
    graphs = [ :load_1m, :load_5m, :load_15m ]

#TODO cpu and here - sort by timestamp
    chart[:graph_data] = Load.where(:timestamp.gte => options[:start]).
                              where(:timestamp.lt => options[:end]).
			      where(:host_id => options[:host_id]).
			      where(:plugin_id => options[:plugin_id]).
			      order_by(timestamp: :asc)

    host_facts = Facts.get_latest_facts_for_host(options[:host_id])
    unless host_facts.nil?
      cores_total = host_facts['facts']['processors']['count']
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
        :inside => false,
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
        :inside => false,
        :line_alpha => 1,
        :fill_alpha => 0.1,
        :position => 'bottom'},
      # red zone - critical
        {:value => cores_total * 2,
        :to_value => cores_total * 10,
        :value_axis => 'valueAxis1',
        :line_color => "#FF0000",
        :fill_color => "#FF0000",
        :line_thickness => 1,
        :dash_length => 5,
        :label => "",
        :inside => false,
        :line_alpha => 1,
        :fill_alpha => 0.1,
        :position => 'bottom'}]
    end
    chart[:guides] = guides
    chart
  end
  
  def self.graphs
    { 
      :load_15m => { 
        :hidden => false,
        :line_color => "#FF0000",
        :line_thickness => 3,
        :title => "Load 15 minutes average"},
       :load_5m => {
         :hidden => false,
         :line_color => "#FFFF00",
         :line_thickness => 2,
         :title => "Load 5 minutes average"},
       :load_1m => {
         :hidden => false,
         :line_color => "#FFaa00",
         :line_thickness => 1,
         :title => "Load 1 minute average"}
     }
  end
end
