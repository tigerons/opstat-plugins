class Bsdnet
class BytesInOut
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaNotStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, host_id: 1, plugin_id: 1},{background: true})

  def self.chart_data(options = {})
    charts = []
    options[:interface] = 'vlan254'
    charts << self.bytes_chart(options)
    #TODO interfaces??
    return charts
  end

  def self.bytes_chart(options)
    chart = self.chart_structure({:title => "Network traffic in/out", :value_axis => { :title => "Network traffic [Bytes]"}})
    #TODO - sort by date
    values = Bsdnet::BytesInOut.where(:timestamp.gte => options[:start]).
                                where(:timestamp.lt => options[:end]).
				where(:host_id => options[:host_id]).
				where(:plugin_id => options[:plugin_id]).
				order(timestamp: :asc)
    prev = nil
    values.each do |data|
      if prev.nil?
        prev = data
        next
      end
      bytes_in_per_sec = (data[:bytes_in_v4] - prev[:bytes_in_v4])/(data[:timestamp] - prev[:timestamp])
      bytes_out_per_sec = (data[:bytes_out_v4] - prev[:bytes_out_v4])/(data[:timestamp] - prev[:timestamp])
      chart[:graph_data] << {
        :timestamp => data[:timestamp],
        :bytes_out => bytes_out_per_sec.to_i,
        :bytes_in => bytes_in_per_sec.to_i
      }
      prev = data
    end

    chart
  end

  def self.graphs
    {
      :bytes_in => { :line_color => '#FF3300' },
      :bytes_out => {:line_color => '#00FF00' }
    }
  end
end
end

