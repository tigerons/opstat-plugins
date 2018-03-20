class Temper
  include MongoMapper::Document
  include Graphs::AreaNotStackedChart
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts << self.temper_chart(options)
    return charts
  end
  
  def self.temper_chart(options)
    chart = self.chart_structure({:title => "Temperature in [C]", :value_axis => { :title => "Temperature"}})
#    data = {
#               :value_axes => [
#                          { 
##			    :stack_type => 'regular',
#                          }
#                        ],
#             }


    #TODO - get fields from above DRY
    chart[:graph_data] = Temper.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timetamp).all
    chart
  end

  def self.axes_defaults
    {
      :value_axis => {:title => 'Temperature in C'}
    }
  end

  def self.graphs
    {
      :temperature => {
        :value_field => "Temperature",
        :hidden => false,
        :line_color => "#FF0000",
        :title => "Temperature"
      }
    }
  end
end
