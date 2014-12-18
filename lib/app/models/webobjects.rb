class Webobjects
  include MongoMapper::Document
  set_collection_name "opstat.reports"
  timestamps!

  def self.chart_data(options = {})
    charts = []
    charts = self.all_applications_charts(options)
    return charts
  end

  def self.all_sensors_applications_charts(options = {})
    charts = []
    Webobjects.where( { :timestamp => {:$gte => options[:start],:$lt => options[:end]} , :plugin_type => 'webobjects'} ).order(:timetamp).group_by{|u| u.application_name}.each_pair do |app, stats|
      charts << self.application_charts(app,stats)
    end
    return charts.flatten
  end

  def self.all_applications_charts(options = {})
    charts = []
    Webobjects.where( { :timestamp => {:$gte => options[:start],:$lt => options[:end]} , :host_id => options[:host_id], :plugin_id => options[:plugin_id]} ).order(:timetamp).group_by{|u| u.application_name}.each_pair do |app, stats|
      charts << self.application_charts(app,stats)
    end
    return charts.flatten
  end

  def self.application_charts(app,stats)
    prev = nil
    report_data = Hash.new
    @quant = 60
    chart_data = {}
    instances = Hash.new
    stats.each do |stat|
      instances[stat[:instance]] ||= true
      rounded_timestamp = stat[:timestamp].to_i - ( stat[:timestamp].to_i % @quant )
      report_data[:sessions] ||= Hash.new
      report_data[:transactions] ||= Hash.new
      report_data[:sessions][rounded_timestamp] ||= Hash.new
      report_data[:transactions][rounded_timestamp] ||= Hash.new

      #TODO resolve problems with breaks in stat series for each instance
      report_data[:sessions][rounded_timestamp][stat[:instance]] = stat[:sessions] 
      report_data[:transactions][rounded_timestamp][stat[:instance]] = stat[:transactions]
    end

    prev = nil
    chart_data[:tps] ||= []
    report_data[:transactions].each do |timestamp, data_hash|
      if prev.nil? then
        prev = { :timestamp =>  timestamp, :data_hash => data_hash }
        next
      end
      
      time_diff = timestamp.to_i - prev[:timestamp].to_i
      temp = {}
      data_hash.each_pair do |instance, transactions|
        next if prev[:data_hash][instance].nil?
	tps = ((transactions - prev[:data_hash][instance])/time_diff.to_f).round(3)
	next if tps < 0
        temp[instance] = tps
      end
      temp["timestamp"] = timestamp.to_i * 1000
      chart_data[:tps] << temp
      prev = { :timestamp =>  timestamp, :data_hash => data_hash }
    end
 
    chart_data[:sessions] ||= []
    report_data[:sessions].each do |timestamp, data_hash|
      temp = data_hash
      temp["timestamp"] = timestamp.to_i * 1000
      chart_data[:sessions] << temp
    end
    tps = self.tps_graph(app)
    instances.keys.each do |graph|
      #TODO value_axis
      #TODO merge set values with default
      ##TODO sort by timestamp
      tps[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph.to_s,  :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.1, :graph_type => 'line' }
    end
    
    sessions = sessions_graph(app)
    instances.keys.each do |graph|
      #TODO value_axis
      #TODO merge set values with default
      ##TODO sort by timestamp
      sessions[:graphs] << { :value_axis => 'valueAxis1', :value_field => graph, :balloon_text => "[[title]]: ([[value]])", :line_thickness => 1, :line_alpha => 1, :fill_alphas => 0.1, :graph_type => 'line' }
    end
    sessions[:graph_data] = chart_data[:sessions]
    tps[:graph_data] = chart_data[:tps]
    [tps,sessions]
  end
    
  def self.tps_graph(app)
    return {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Transactions per sec',
			    :position => 'left',
			    :min_max_multiplier => 1,
			    :stack_type => 'regular',
                            :include_guides_in_min_max => 'true',
			    :grid_alpha => 0.1
			  }
			],
               :graph_data => [],
	       :category_field => 'timestamp',
	       :graphs => [],
               :title => "Transactions per sec - #{app} application",
	       :title_size => 20
	     }
  end

  def self.sessions_graph(app)
    return {
               :value_axes => [
	                  { 
			    :name => "valueAxis1",
			    :title => 'Number of sessions',
			    :position => 'left',
			    :min_max_multiplier => 1,
			    :stack_type => 'regular',
                            :include_guides_in_min_max => 'true',
			    :grid_alpha => 0.1
			  }
			],
               :graph_data => [],
	       :category_field => 'timestamp',
	       :graphs => [],
	       :title => "Number of sessions - #{app} application",
	       :title_size => 20
	     }
  end

  def self.axes_defaults
    {
      :sessions => {
        :value_axis => {:title => 'Sessions'}
      },
      :tps => {
        :value_axis => {:title => 'Transactions per second'}
      }

    }
  end

  def self.legend
    @legend = {}
  end
end
Webobjects.ensure_index( [ [:timestamp, 1], [:host_id, 1] , [:plugin_id,1] ] )
