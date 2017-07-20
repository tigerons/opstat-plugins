pwd  = File.dirname(File.expand_path(__FILE__))
require "#{pwd}/bsdnet/bytes_in_out.rb"

class Bsdnet
  def self.chart_data(options = {})
    charts = []
    charts +=  Bsdnet::BytesInOut.chart_data(options)
    return charts
  end
end
