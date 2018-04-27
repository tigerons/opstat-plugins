class Haproxy
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  store_in collection: "opstat.reports"

  field :session_total, type: Integer
  field :session_transmit, type: Integer 
  index({host_id: 1, plugin_id: 1}, {background: true}) 
  
  def self.chart_data(options = {})
    charts = []
    charts << self.haproxy_chart(options)
    return charts
  end

end

  def self.haproxy_chart
    prev = nil
    values.each do |value|
      if prev.nil? then 
	prev = value
	next
      end 
    time_diff = value[:timestamp].to_i - prev[:timestamp].to_i
    chart_data[:graph_data] << { 
      "timestamp" => value[:timestamp],
      "session_total" => (value[:stot].to_i, 
      "session_per_second" => (value[:stot].to_i - prev[:stot].to_i/time_diff).to_i 
   }
    prev = value 
  end
    chart_data 
  end 
  
    
  def self.graphs
    {
      :sesion_total => { :line_color => '#FF3300' },
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

