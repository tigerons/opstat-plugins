class Nagios
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime

  def self.chart_data(options = {})
    charts = []
    charts << self.nagios_chart(options)
    return charts
  end
  
  def self.nagios_chart(options)
    chart = self.chart_structure({:title => "Nagios alerts statistic", :value_axis => { :title => "Number of services"}})
    #TODO - get fields from above DRY
    chart[:graph_data] = Nagios.where(:timestamp.gte => options[:start]).
                                where(:timestamp.lt => options[:end]).
				where(:host_id => options[:host_id]).
				where(:plugin_id => options[:plugin_id]).
				order_by(:timestamp)
    return chart
  end
  
  def self.graphs
     {
       :services_critical => {
         :line_color => "#FF0000",
         :hidden => false,
         :title => "Services with critical errors"
       },
       :services_warning => {
         :line_color => "#FFFF00",
         :hidden => false,
         :title => "Services with warnings"
       },
       :services_unknown => {
         :line_color => "#FFaa00",
         :hidden => false,
         :title => "Services in unknown state"
       },
       :services_ok => {
         :line_color => "#00FF00",
         :hidden => true,
         :title => "Services with no problems"
       }

     }
  end
end
