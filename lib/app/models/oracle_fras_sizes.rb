class OracleFrasSizes
  include MongoMapper::Document
  include Graphs::AreaStackedChart
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

#TODO - files chart
  def self.chart_data(options = {})
    charts = []
    charts = self.all_fras_charts(options)
    return charts
  end

  def self.all_fras_charts(options)
    charts = []
    OracleFrasSizes.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).fields(:timestamp, :used, :free, :path).order(:timetamp).all.group_by{|u| u.path}.each_pair do |path, values|
      charts << self.fra_chart(path, values)
    end
    return charts
  end

  def self.fra_chart(path, values)
    chart = self.chart_structure({:title => "Flash Recovery Area #{path} space usage", :value_axis => { :title => "FRA space usage"}})
    chart[:graph_data] = values

    return chart
  end

  def self.graphs
    {
      :used => { :line_color => '#FF0000' },
      :free => {:line_color => '#00FF00' }
    }
  end
end
