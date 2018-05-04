class Haproxy
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaNotStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, host_id: 1, plugin_id: 1}, {background: true})

  def self.chart_data(options = {})
    charts = []
    charts << self.haproxy_chart(options)
    return charts
  end


  def self.haproxy_chart(options)
   chart = self.chart_structure({:title => 'Haproxy test', :value_axis => { :title => "Session per second"}})

   chart[:graph_data] = Haproxy.where(:timestamp.gte => options[:start]).
            where(:timestamp.lt => options[:end]).
            where(:host_id => options[:host_id]).
            where(:plugin_id => options[:plugin_id]).order_by(timestamp: :asc)

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
~                                                                                                                                                                                                                                             
~          
