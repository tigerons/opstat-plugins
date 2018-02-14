class Fpm
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  store_in collection: "opstat.reports"
  field :timestamp, type: DateTime

  def self.chart_data(options = {})
    charts = self.fpms_charts(options)
    return charts
  end

  def self.fpms_charts(options = {})
    charts = []
    Fpm.where(:timestamp.gte => options[:start]).
        where(:timestamp.lt => options[:end]).
	where(:host_id => options[:host_id]).
	where(:plugin_id => options[:plugin_id]).
	order_by(timestamp: :asc).group_by{|u| u.pool}.each_pair do |pool, values|
      charts << self.fpm_chart(pool,values)
    end
    return charts
  end

  def self.fpm_chart(pool, values)
    max_active_processes = 0
    chart_data = {
               :value_axes => self.axes,
               :graph_data => [],
               :graphs => self.graphs,
               :title => "#{pool} FPM pool statistic",
	       :category_field => 'timestamp',
               :title_size => 20,
	       :guides => {}
             }

    prev = nil
    values.each do |value|
      temp = {}
     
      if prev.nil? then
        prev = value 
        next
      end

      time_diff = value[:timestamp].to_i - prev[:timestamp].to_i
      accepted_connections_per_sec = ((value[:accepted_connections] - prev[:accepted_connections])/time_diff.to_f).round(3)
      #Interpolation of no data intervals
      if accepted_connections_per_sec < 0
        prev = value
        next
      end
       
      max_active_processes = value[:processes_active_max] if value[:processes_active_max] > max_active_processes

      temp = {'timestamp' => value[:timestamp]}
      temp[:processes_active] = value[:processes_active]
      temp[:processes_idle] = value[:processes_idle]
      temp[:accepted_connections_per_sec] = accepted_connections_per_sec.to_f
      prev = value
      chart_data[:graph_data] << temp
    end
    chart_data[:guides] = [
      {
        :value => max_active_processes,
        :value_axis => 'valueAxis2',
        :line_color => "#FF0000",
        :line_thickness => 1,
        :dash_length => 5,
        :label => "Max processes",
        :inside => 'true',
        :line_alpha => 1,
        :position => 'bottom',
      }
    ]
    
    return chart_data
  end
  
  def self.graphs
    [
     { :value_field => "processes_active",
	:graph_type => 'line',
       :hidden => false,
       :balloon_text => "[[title]]: ([[value]])",
       :line_color => "#FF0000",
       :line_thickness => 1,
       :line_alpha => 1,
       :fill_alphas => 0.6,
       :title => "Active Processes",
       :value_axis => "valueAxis2"},
     { :value_field => "processes_idle",
	:graph_type => 'line',
       :hidden => false,
       :balloon_text => "[[title]]: ([[value]])",
       :line_color => "#00FF00",
       :line_thickness => 1,
       :line_alpha => 1,
       :fill_alphas => 0.6,
       :title => "Idle processes",
       :value_axis => "valueAxis2"},
     { :value_field => "accepted_connections_per_sec",
       :graph_type => 'line',
       :hidden => false,
       :balloon_text => "[[title]]: ([[value]])",
       :line_color => "#0000FF",
       :line_thickness => 3,
       :line_alpha => 1,
       :fill_alphas => 0,
       :title => "Accepted connections per second",
       :value_axis => "valueAxis1"},
    ]
  end

  def self.axes
    [
      {
	:name => 'valueAxis1',
        :title => 'Accepted connections per second',
	:position => 'right',
        :min_max_multiplier => 1,
        :grid_alpha => 0.07,
        :include_guides_in_min_max => 'true',
        :stack_type => "none"
      },
      {
	:name => 'valueAxis2',
        :title => 'Active processes',
	:position => 'left',
        :grid_alpha => 0.07,
        :min_max_multiplier => 1,
        :include_guides_in_min_max => 'true',
        :stack_type => "regular"
      }
    ]

  end
end
