class OracleTablespacesSizes
  include MongoMapper::Document
  include Graphs::AreaStackedChart
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts = self.all_tablespaces_charts(options)
    return charts
  end

  def self.all_tablespaces_charts(options)
    charts = []
    OracleTablespacesSizes.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).fields(:timestamp, :used, :free, :name).order(:timetamp).all.group_by{|u| u.name}.each_pair do |tablespace, values|
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
