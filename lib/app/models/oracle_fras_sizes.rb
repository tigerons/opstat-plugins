class OracleFrasSizes
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Graphs::AreaStackedChart
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime

#TODO - files chart
  def self.chart_data(options = {})
    charts = []
    charts = self.all_fras_charts(options)
    return charts
  end

  def self.all_fras_charts(options)
    charts = []
    OracleFrasSizes.where(:timestamp.gte => options[:start]).
                    where(:timestamp.lt => options[:end]).
		    where(:host_id => options[:host_id]).
		    where(:plugin_id => options[:plugin_id]).
		    order_by(timestamp: :asc).group_by{|u| u.path}.each_pair do |path, values|
      charts << self.fra_chart(path, values)
    end
    return charts
  end

  def self.fra_chart(path, values)
    chart = self.chart_structure({:title => "Flash Recovery Area #{path} space usage", :value_axis => { :title => "FRA space usage"}})
    chart[:graph_data] = values

    return chart
  end

  def self.graphs
    {
      :used => { :line_color => '#FF0000' },
      :free => {:line_color => '#00FF00' }
    }
  end
end
