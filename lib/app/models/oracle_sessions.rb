class OracleSessions
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime

  def self.chart_data(options = {})
    charts = []
    charts << self.sessions_chart(options)
    return charts
  end

  def self.sessions_chart(options)
    chart = self.chart_structure({:title => "Oracle sessions", :value_axis => { :title => "Sessions count"}})
    chart[:graph_data] = OracleSessions.where(:timestamp.gte => options[:start]).
                                        where(:timestamp.lt => options[:end]).
					where(:host_id => options[:host_id]).
					where(:plugin_id => options[:plugin_id]).
					order_by(timestamp: :asc)
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
