class Network 
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaNotStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  field :bytes_receive, type: Integer
  field :bytes_transmit, type: Integer
  index({timestamp: 1, host_id: 1 , plugin_id: 1},{background: true})

  def self.chart_data(options = {})
    charts = []
    charts = self.all_interfaces_charts(options)
    return charts
  end

  def self.all_interfaces_charts(options)
    charts = []
    Network.where(:timestamp.gte => options[:start]).
            where(:timestamp.lt => options[:end]).
	    where(:host_id => options[:host_id]).
	    where(:plugin_id => options[:plugin_id]).
	    order_by(timestamp: :asc).group_by{|u| u.interface}.each_pair do |interface, values|
      charts << self.interface_chart(interface, values)
    end
    return charts
  end

  def self.interface_chart(interface, values)
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
        "bytes_receive_per_sec" => ((value[:bytes_receive].to_i - prev[:bytes_receive].to_i)/time_diff).to_i,
        "bytes_transmit_per_sec" => ((value[:bytes_transmit].to_i - prev[:bytes_transmit].to_i)/time_diff).to_i
      }
      prev = value 
      
    end

    chart_data
  end
    
  def self.graphs  
    {
      :bytes_receive_per_sec => { :line_color => '#0033FF' },
      :bytes_transmit_per_sec => {:line_color => '#00FF00' }
    }
  end
end
