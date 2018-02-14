class Disk 
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime
  index({timestamp: 1, host_id: 1, plugin_id: 1})

  def self.chart_data(options = {})
    charts = []
    charts = self.all_disks_charts(options)
    return charts
  end

  def self.all_disks_charts(options)
    charts = []
    Disk.where(:timestamp.gte => options[:start]).
         where(:timestamp.lt => options[:end]).
	 where(:host_id => options[:host_id]).
	 where(:plugin_id => options[:plugin_id]).
	 order_by(timestamp: :asc).group_by{|u| u.mount}.each_pair do |mount, values|
      charts << self.disk_chart(mount, values)
    end
    return charts
  end

  def self.disk_chart(mount, values)
    chart = self.chart_structure({:title => "Disk space usage for #{mount}", :value_axis => { :title => "Disk usage in KB"}})
    #TODO - get fields from above DRY
    chart[:graph_data] = values
    chart
  end

  def self.graphs
    {
      :block_used => {
        :hidden => false,
        :line_color => "#FF0000",
        :line_thickness => 3,
        :title => "block used"
      },
      :block_free => { 
         :hidden => false,
         :line_color => "#00FF00",
         :line_thickness => 3,
         :title => "block free"
      }
    }
  end
end
