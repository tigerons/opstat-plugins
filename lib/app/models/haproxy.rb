class Haproxy
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, host_id: 1, plugin_id: 1})

  def self.chart_data(options = {})
    charts = []
    charts = self.haproxy_charts(options)
    return charts
  end

  def self.haproxy_charts(options)
    charts = []
    Haproxy.where(:timestamp.gte => options[:start]).
         where(:timestamp.lt => options[:end]).
         where(:host_id => options[:host_id]).
         where(:plugin_id => options[:plugin_id]).
         order_by(timestamp: :asc).group_by{|u| u._pxname}.each_pair do |haproxy_name, values|
      charts << self.haproxy_chart(mount, values)
    end
    return charts
  end

  def self.haproxy_chart(haproxy_name, values)
    chart = self.chart_structure({:title => "Haproxy #{haproxy_name}", :value_axis => { :title => "Haproxy"}})
    #TODO - get fields from above DRY
    chart[:graph_data] = values
    chart
  end

  def self.graphs
    {
        :stot => { :line_color => '#00FFAC'},
      :conn_tot => { :line_color => '#C0FF00'},
      :bin => { :line_color => '#FCA0FF'}
}
  end
end
