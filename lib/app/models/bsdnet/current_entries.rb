class Bsdnet
class CurrentEntries
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaNotStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime

  def self.chart_data(options = {})
    charts = []
    options[:interface] = 'vlan254'
    charts << self.entries_chart(options)
    return charts
  end

  def self.entries_chart(options)
    chart = self.chart_structure({:title => "Network current entries", :value_axis => { :title => "Network entries []"}})
    values = Bsdnet::CurrentEntries.where(:timestamp.gte => options[:start]).
                                    where(:timestamp.lt => options[:end]).
				    where(:host_id => options[:host_id]).
				    where(:plugin_id => options[:plugin_id]).
				    order(timestamp: :asc)
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
