class Apache2
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, host_id: 1, plugin_id: 1},{background: true})

  def self.chart_data(options = {})
    charts = []
    charts = self.all_vhosts_charts(options)
    return charts
  end

  def self.all_vhosts_charts(options)
    charts = []
    stats = Apache2.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timestamp).all.group_by{|v| v.vhost_name}
    charts = self.vhosts_requests_and_bytes_per_sec(stats)
    return charts
  end

  def self.vhosts_requests_and_bytes_per_sec(stats)
    charts = []
    stats.each_pair do |vhost,data|
      chart_bytes = self.chart_structure({:title => "Bytes sent per second for #{vhost} vhost", :value_axis => { :title => "Bytes sent per second"}})
      chart_requests = self.chart_structure({:title => "Request sent per second for #{vhost} vhost", :value_axis => { :title => "request sent per second"}})

      prev = {}
      statuses = {}
      data.each do |vhost_data|
        current = {:bytes_sent_per_sec => {}, :requests_per_sec => {}}
        current[:bytes_sent_per_sec]['timestamp'] = vhost_data['timestamp'].to_f * 1000
	statuses.keys.each do |s|
          current[:bytes_sent_per_sec][s] = 0
	end
        current[:requests_per_sec]['timestamp'] = vhost_data['timestamp'].to_f * 1000
        statuses.keys.each do |s|
          current[:requests_per_sec][s] = 0
	end
        vhost_data['stats'].each_pair do |status, values|
          statuses[status] = true
          unless prev.has_key?(status) then
            prev[status] = values
	    prev[status]['timestamp'] = vhost_data['timestamp']
            next
          end
      
          time_diff = vhost_data['timestamp'].to_i - prev[status]['timestamp'].to_i
          bytes_sent_per_sec = ((values["bytes_sent"] - prev[status]['bytes_sent'])/time_diff.to_f).round(3)
          requests_per_sec = ((values['requests'] - prev[status]['requests'])/time_diff.to_f).round(3)
	  #TODO Interpolation of no data intervals
	  #TODO take into account requests also
	  if bytes_sent_per_sec < 0
	    prev[status] = values
	    prev[status]['timestamp'] = vhost_data['timestamp']
	    next
	  end
       
          current[:bytes_sent_per_sec][status] = bytes_sent_per_sec.to_f
          current[:requests_per_sec][status] = requests_per_sec.to_f
	  prev[status] = values
	  prev[status]['timestamp'] = vhost_data['timestamp']
	end
        chart_requests[:graph_data] << current[:requests_per_sec]
        chart_bytes[:graph_data] << current[:bytes_sent_per_sec]
      end
      statuses.keys.sort.each do |status|
	properties =  self.statuses_properties.select{|a| a[:value_field] == status.to_s}.first
	p status
        chart_requests[:graphs] << { :value_axis => 'valueAxis1', :value_field => status.to_s, :line_color => properties[:line_color],  :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line' }
        chart_bytes[:graphs] << { :value_axis => 'valueAxis1', :value_field => status.to_s, :line_color => properties[:line_color],  :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.8, :graph_type => 'line' }
      end
      charts << chart_bytes << chart_requests
    end
    charts
  end

  def self.statuses_properties
    [
     { :value_field => "200",
       :hidden => false,
       :line_color => "#00FF00",
       :line_thickness => 3,
       :title => "Status 200"},
     { :value_field => "202",
       :hidden => false,
       :line_color => "#00FF33",
       :line_thickness => 3,
       :title => "Status 202"},
     { :value_field => "204",
       :hidden => false,
       :line_color => "#00FF66",
       :line_thickness => 3,
       :title => "Status 204"},
     { :value_field => "206",
       :hidden => false,
       :line_color => "#00FF88",
       :line_thickness => 3,
       :title => "Status 206"},
     { :value_field => "300",
       :hidden => false,
       :line_color => "#FFFF00",
       :line_thickness => 3,
       :title => "Status 301"},
     { :value_field => "301",
       :hidden => false,
       :line_color => "#FFEE00",
       :line_thickness => 3,
       :title => "Status 300"},
     { :value_field => "302",
       :hidden => false,
       :line_color => "#FFDD00",
       :line_thickness => 3,
       :title => "Status 302"},
     { :value_field => "303",
       :hidden => false,
       :line_color => "#FFAA00",
       :line_thickness => 3,
       :title => "Status 303"},
     { :value_field => "304",
       :hidden => false,
       :line_color => "#FF9900",
       :line_thickness => 3,
       :title => "Status 304"},
     { :value_field => "400",
       :hidden => false,
       :line_color => "#FF8800",
       :line_thickness => 3,
       :title => "Status 400"},
     { :value_field => "403",
       :hidden => false,
       :line_color => "#FF6600",
       :line_thickness => 3,
       :title => "Status 403"},
     { :value_field => "404",
       :hidden => false,
       :line_color => "#FF4400",
       :line_thickness => 3,
       :title => "Status 404"},
     { :value_field => "405",
       :hidden => false,
       :line_color => "#EE0000",
       :line_thickness => 3,
       :title => "Status 405"},
     { :value_field => "406",
       :hidden => false,
       :line_color => "#CC0000",
       :line_thickness => 3,
       :title => "Status 406"},
     { :value_field => "407",
       :hidden => false,
       :line_color => "#BB0000",
       :line_thickness => 3,
       :title => "Status 407"},
     { :value_field => "408",
       :hidden => false,
       :line_color => "#AA0000",
       :line_thickness => 3,
       :title => "Status 408"},
     { :value_field => "420",
       :hidden => false,
       :line_color => "#550000",
       :line_thickness => 3,
       :title => "Status 420"},
     { :value_field => "500",
       :hidden => false,
       :line_color => "#FF0000",
       :line_thickness => 3,
       :title => "Status 500"},
     { :value_field => "501",
       :hidden => false,
       :line_color => "#FF2200",
       :line_thickness => 3,
       :title => "Status 501"},
     { :value_field => "502",
       :hidden => false,
       :line_color => "#FF4400",
       :line_thickness => 3,
       :title => "Status 502"},
     { :value_field => "503",
       :hidden => false,
       :line_color => "#FF6600",
       :line_thickness => 3,
       :title => "Status 503"}
    ]
  end

  def self.graphs
    {}
  end
end
