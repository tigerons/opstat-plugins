class Haproxy
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  field :session_total, type: Integer
  field :session_transmit, type: Integer 
  index({timestamp: 1, host_id: 1, plugin_id: 1}, {background: true}) 
  
  def self.chart_data(options = {})
    charts = []
    charts << self.haproxy_charts(options)
    return charts
  end


  def self.haproxy_charts(options)
    charts = []
   Haproxy.where(:timestamp.gte => options[:start]).
            where(:timestamp.lt => options[:end]).
	    where(:host_id => options[:host_id]).
	    where(:plugin_id => options[:plugin_id]).
	    order_by(timestamp: :asc).group_by{|u| u.interface}.each_pair do |interface, values|
      charts << self.interface_chart(interface, values)
    end
    return charts
  end
   
 def self.haprox_chart(interface, values)
    chart_data = self.chart_structure({:title => "Network traffic for #{interface}", :value_axis => { :title => "Network traffic for #{interface}"}})
    
    prev = nil
    values.each do |value|
      if prev.nil? then
        prev = value
        next
      end
      time_diff = value[:timestamp].to_i - prev[:timestamp].to_i
      chart_data[:graph_data] << {
        "timestamp" => value[:timestamp],
        "sesion_per_second" => ((value[:stot].to_i)/time_diff).to_i
      }
      prev = value 
      
    end

    chart_data
  end
    
  def self.graphs
    {
 
      :session_per_second => { :line_color => '#00FF00'}, 
      :_pxname => { :line_color => '#00FF00'}, 
      :svname  => { :line_color => '#00FF00'},
      :qcur => { :line_color => '#00FF00'}
      :qmax => { :line_color => '#00FF00'},
      :scur => { :line_color => '#00FF00'},
      :slim => { :line_color => '#00FF00'},
      :stot => { :line_color => '#00FF00'},
      :bin => { :line_color => '#00FF00'},
      :bout => { :line_color => '#00FF00'},
      :hrsp_1xx => { :line_color => '#00FF00'},
      :hrsp_2xx => { :line_color => '#00FF00'},
      :hrsp_3xx => { :line_color => '#00FF00'},
      :hrsp_4xx => { :line_color => '#00FF00'},
      :hrsp_5xx => { :line_color => '#00FF00'},
      :hrsp_other => { :line_color => '#00FF00'},
      :req_tot => { :line_color => '#00FF00'},
      :conn_tot => { :line_color => '#00FF00'}
    }
    []
  end
end

