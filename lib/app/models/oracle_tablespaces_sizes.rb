class OracleTablespacesSizes
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime

  def self.chart_data(options = {})
    charts = []
    charts = self.all_tablespaces_charts(options)
    return charts
  end

  def self.all_tablespaces_charts(options)
    charts = []
    OracleTablespacesSizes.where(:timestamp.gte => options[:start]).
                           where(:timestamp.lt => options[:end]).
			   where(:host_id => options[:host_id]).
			   where(:plugin_id => options[:plugin_id]).
			   order(timestamp: :asc).group_by{|u| u.name}.each_pair do |tablespace, values|
      charts << self.tablespace_chart(tablespace, values)
    end
    return charts
  end

  def self.tablespace_chart(tablespace, values)
    chart = self.chart_structure({:title => "Tablespace #{tablespace} space usage", :value_axis => { :title => "Size in bytes"}})
    chart[:graph_data] = values
    return chart
  end

  def self.graphs
    {
      :used => {
        :hidden => false,
        :line_color => "#FF0000",
        :line_thickness => 3,
	:balloon_text => "[[title]]: [[value]] ([[percents]]%)",
        :title => "Bytes used"
      },
      :free => {
        :hidden => false,
        :line_color => "#00FF00",
        :line_thickness => 3,
	:balloon_text => "[[title]]: [[value]] ([[percents]]%)",
        :title => "Bytes free"
      }
    }
  end
end
