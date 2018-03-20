class Bsdnet
  include MongoMapper::Document
  include Graphs::AreaNotStackedChart
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

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
    values = Bsdnet.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).order(:timetamp).all
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
Bsdnet.ensure_index( [ [:timestamp, 1], [:host_id, 1] , [:plugin_id,1] ] )
