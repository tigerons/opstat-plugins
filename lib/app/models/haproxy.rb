class Haproxy
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  field :stot, type: Integer
  index({timestamp: 1, host_id: 1, plugin_id: 1}, {background: true})

  def self.chart_data(options = {})
    charts = []
    charts = self.haproxy_charts(options)
    return charts
  end

  def self.haproxy_charts(options)
    haproxy_instance =[]
    charts = []
    Haproxy.where(:timestamp.gte => options[:start]).
            where(:timestamp.lt => options[:end]).
            where(:host_id => options[:host_id]).
            where(:plugin_id => options[:plugin_id]).
              order_by(timestamp: :asc).group_by{|u| u[:name]}.each_pair do |instance, values|
                charts << self.haproxy_chart(instance, values)
              end
            return charts
  end

  def self.haproxy_chart(instance, values)
    chart = self.chart_structure({:title => "Haproxy #{instance}", :value_axis => { :title => "Session per second"} })
    prev = {}
    chart_data = {}
    instances = Hash.new
    values.each do |value|
      instances[value[:stot]] ||= true
      unless prev.has_key?(value[:stot]) then
        prev[value[:stot]] = value
        next
      end
      time_diff = value[:timestamp].to_i - prev[value[:stot]][:timestamp].to_i
      chart[:graph_data] << {
        "timestamp" => value[:timestamp],
        "session_per_sec" => (value[:summary][:stot] - prev[value[:stot]][:summary][:stot]).to_f/time_diff
      }
      prev[value[:stot]] = value
    end
    chart
  end

  def self.graphs
    { 
      :session_per_sec => { :line_color => '#00FFAC', :line_thickness => 4, :title => "session_per_second", :hidden => false},
    }
  end
end 

