class Memory
  include MongoMapper::Document
  include Graphs::AreaStackedChart
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts << self.memory_chart(options)
    return charts
  end
  
  def self.memory_chart(options)
    chart = self.chart_structure({:title => "Host memory usage", :value_axis => { :title => "Memory size in KB"}})


    #TODO - get fields from above DRY
    chart[:graph_data] = Memory.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).fields(:used, :cached, :buffers, :swap_used, :free, :timestamp).order(:timetamp).all

    guides = []
    memory_total = Facts.get_fact({:name => "memorytotal", :host_id => options[:host_id]})
    unless memory_total.nil?
      guide = {}
      require 'ruby-units'
      #TODO Temporary workaround - change plugin data units from KiB to B
      memory_in_si = memory_total.value.sub("GB","GiB").sub("MB","MiB")
      guide[:value] = Unit(memory_in_si).to('KiB').scalar
      guide[:value_axis] = 'valueAxis1'
      guide[:line_color] = "#FF0000"
      guide[:line_thickness] = 1
      guide[:dash_length] = 5
      guide[:label] = "Total physical memory: #{memory_in_si} (by facter)"
      guide[:inside] = 'true'
      guide[:line_alpha] = 1
      guide[:position] = 'bottom'
      guides << guide
    end
    chart[:guides] = guides
    chart
  end

  def self.graphs
    {
      :used => { :line_color => '#FF3300' },
      :cached => {:line_color => '#FFFF00' },
      :buffer => {:line_color => '#FFaa33' },
      :free => {:line_color => '#00FF00' },
      :swap_used => {:line_color => '#00FFFF' }
    }
  end
end

Memory.ensure_index( [ [:timestamp, 1], [:host_id, 1] , [:plugin_id,1] ] )
