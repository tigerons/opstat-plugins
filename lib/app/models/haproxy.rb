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
   guides = []
   unless  host_facts.nil?
   guide = {}
   require 'ruby-units'
      guide[:value] = 'forntend-http'
      guide[:value_axis] = 'valueAxis1'
      guide[:line_color] = "#00FFaa33"
      guide[:line_thickness] = 1
      guide[:dash_length] = 5
      guide[:label] = "Total physical"
      guide[:inside] = true
      guide[:line_alpha] = 1
      guide[:position] = 'bottom'
      guides << guide

  end
   chart[:guides] = guides
   chart

 end

  def self.graphs
    {
      :qcur => { :line_color => '#00FF00'},
      :qmax => { :line_color => '#FFaa33'},
      :scur => { :line_color => '#00FF00'},
      :slim => { :line_color => '#0F0F0F'},
      :stot => { :line_color => '#00FF00'},
      :conn_tot => { :line_color => '#00FF00'}
    }
  end
end
