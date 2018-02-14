class DiskIo
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::LineChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, hostname: 1, ip_address: 1},{background: true})

  def self.chart_data(options = {})
    charts = []
    charts << self.disk_io_charts(options)
    return charts
  end

  def self.disk_io_charts(options)
    chart = self.chart_structure({:title => "Host load average", :value_axis => { :title => "Memory size in KB"},:include_guides_in_min_max => false})

    #CHOOSE HERE which
    # TODO ADD ALL TYPES
    #TODO ADD GUIDES - if num of cores from facter
    graphs = [ :load_1m, :load_5m, :load_15m ]

#TODO cpu and here - sort by timestamp
    chart[:graph_data] = DiskIo.where(:timestamp.gte => options[:start]).
                                where(:timestamp.lt => options[:end]).
				where(:host_id => options[:host_id]).
				where(:plugin_id => options[:plugin_id]).
				order(timestamp: :asc)

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
