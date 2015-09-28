class Disk 
  include MongoMapper::Document
  include Graphs::AreaStackedChart
  set_collection_name "opstat.reports"
  key :timestamp, Time
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts = self.all_disks_charts(options)
    return charts
  end

  def self.all_disks_charts(options)
    charts = []
    Disk.where( {:timestamp => { :$gte => options[:start],:$lt => options[:end]}, :host_id => options[:host_id], :plugin_id => options[:plugin_id] }).fields(:timestamp, :block_used, :block_free, :mount).order(:timetamp).all.group_by{|u| u.mount}.each_pair do |mount, values|
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
Disk.ensure_index( [ [:timestamp, 1], [:host_id, 1] , [:plugin_id,1] ] )
