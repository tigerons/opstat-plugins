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

  def self.frontends_haproxy_charts(options)
    charts = []
    Haproxy.where(:timestamp.gte => options[:start]).
            where(:timestamp.lt => options[:end]).
            where(:host_id => options[:host_id]).
            where(:plugin_id => options[:plugin_id]).
              order_by(timestamp: :asc).group_by{ |haproxy| haproxy.frontends }.each_pair do |haproxy_name, values|
                charts << self.haproxy_chart(haproxy_name, values)
              end
    return charts
  end

  def self.backends_haproxy_charts(options)
    charts = []
    Haproxy.where(:timestamp.gte => options[:start]).
            where(:timestamp.lt => options[:end]).
            where(:host_id => options[:host_id]).
            where(:plugin_id => options[:plugin_id]).
              order_by(timestamp: :asc).group_by{ |haproxy| haproxy.backends }.each_pair do |haproxy_name, values|
                haproxy_name.each do |backend_instance|
                charts << self.haproxy_chart(haproxy_name, values)
              end
    return charts
  end
   
  def self.haproxy_charts(options)
    charts = []
    Haproxy.where(:timestamp.gte => options[:start]).
            where(:timestamp.lt => options[:end]).
            where(:host_id => options[:host_id]).
            where(:plugin_id => options[:plugin_id]).
              order_by(timestamp: :asc).group_by{ |haproxy| haproxy.frontends }.each_pair do |haproxy_name, values|
                haproxy_name.each do |frontend_instance|
                  charts << self.haproxy_chart(frontend_instance, values)
                end
              end
    return charts
  end


  def self.haproxy_chart(name, values)
    chart = self.chart_structure({:title => "Haproxy #{frontend_instance[:name]}", :value_axis => { :title => "Session per second"}})
    prev = {}
    chart_data = {}
    instances = Hash.new
    values.each do |value|
      instances[value[:svname]] ||= true
      unless prev.has_key?(value[:svname]) then
        prev[value[:svname]] = value
        next
      end
      time_diff = value[:timestamp].to_i - prev[value[:svname]][:timestamp].to_i
      chart[:graph_data] << {
      "timestamp" => value[:timestamp].to_i,
      "session_per_sec" => ((value[:stot].to_i - prev[value[:svname]][:stot].to_i)/time_diff).to_i,
      }
      prev[value[:svname]] = value
    end
    chart
  end
  def self.instances_graph(instances)
    return self.chart_structure({ :title => "Transactions per second #{instances} instances", :value_axis => { :title => "Number of sessions"}})
  end

  def self.graphs
    {
      :session_per_sec => { :line_color => '#00FFAC', :line_thickness => 4, :title => "session_per_second", :hidden => false},
    }
  end

