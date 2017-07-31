
class Bsdnet
class CurrentEntries
  include MongoMapper::Document
  include Graphs::AreaNotStackedChart
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    options[:interface] = 'vlan254'
    charts << self.entries_chart(options)
    return charts
  end

  def self.entries_chart(options)
    chart = self.chart_structure({:title => "Network current entries", :value_axis => { :title => "Network entries []"}})
    values = Bsdnet::CurrentEntries.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timetamp).all
    chart[:graph_data] = values
    chart
  end

  def self.graphs
    {
      :current_entries => { :line_color => '#FF3300' },
    }
  end
end
end
