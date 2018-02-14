class Memory
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, host_id: 1, plugin_id: 1},{background: true} )

  def self.chart_data(options = {})
    charts = []
    charts << self.memory_chart(options)
    return charts
  end
  
  def self.memory_chart(options)
    chart = self.chart_structure({:title => "Host memory usage", :value_axis => { :title => "Memory size in KB"}})
    #TODO - get fields from above DRY
    chart[:graph_data] = Memory.where(:timestamp.gte => options[:start]).
                                where(:timestamp.lt => options[:end]).
				where(:host_id => options[:host_id]).
				where(:plugin_id => options[:plugin_id]).order_by(timestamp: :asc)

    guides = []
    host_facts = Facts.get_latest_facts_for_host(options[:host_id])
    unless host_facts.nil?
      memory_total_bytes = host_facts['facts']['memory']['system']['total_bytes']
      memory_total_kibytes = memory_total_bytes/1024
      guide = {}
      require 'ruby-units'
      guide[:value] = memory_total_kibytes
      guide[:value_axis] = 'valueAxis1'
      guide[:line_color] = "#FF0000"
      guide[:line_thickness] = 1
      guide[:dash_length] = 5
      guide[:label] = "Total physical memory: #{memory_total_kibytes}KiB (by facter)"
      guide[:inside] = true
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
      :buffers => {:line_color => '#FFaa33' },
      :free => {:line_color => '#00FF00' },
      :swap_used => {:line_color => '#00FFFF' }
    }
  end
end
