class OracleSessions
  include MongoMapper::Document
  include Graphs::AreaStackedChart
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts << self.sessions_chart(options)
    return charts
  end

  def self.sessions_chart(options)
    chart = self.chart_structure({:title => "Oracle sessions", :value_axis => { :title => "Sessions count"}})
    chart[:graph_data] = OracleSessions.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timetamp).all
    return chart
  end

  def self.graphs
    {
      :used => {
        :hidden => false,
        :line_color => "#FF0000",
        :line_thickness => 3,
	:balloon_text => "[[title]]: [[value]] ([[percents]]%)",
        :title => "Session used"
      },
      :free => {
        :hidden => false,
        :line_color => "#00FF00",
        :line_thickness => 3,
	:balloon_text => "[[title]]: [[value]] ([[percents]]%)",
        :title => "Sessions free"
      }
    }
  end
end
