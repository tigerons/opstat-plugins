module Opstat
module Plugins

class Apache2 < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    return @external_plugin[:object].get
  end

  def set_external_plugin=(external)
    @external_plugin[:object] = external
  end

  def external_plugin
    return @external_plugin
  end
end

module UDPExternalPlugins
  class  Apache2 < EventMachine::Connection
    include Logging
    def initialize(options)
      @log_level = options['log_level'] if options.has_key?('log_level')
      logger.info "Create external plugin"
      logger.debug "External plugin options :#{options}"
      require 'json'
      require 'apachelogregex'
      @log_format = options['log_format']
      @log_format ||= '%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O'
      @stat = Hash.new
      @parser = ApacheLogRegex.new(@log_format)
    end
    def post_init
      logger.debug "someone connected!"
    end

    #TODO - something with parse everty line - skips some correct lines
    def receive_data data
      logger.debug data
      line = data.split(': ')[1]
      parse(line)
    end

    def unbind
      logger.debug "someone disconnected!"
    end

  def parse(line)
    data = @parser.parse(line)
    if data
      logger.debug data
      @stat[data['%v'] ] ||= Hash.new
      @stat[data['%v'] ] [data['%>s']] ||= Hash.new
      @stat[data['%v'] ] [data['%>s']] [:requests] ||= 0
      @stat[data['%v'] ] [data['%>s']] [:requests] += 1
      @stat[data['%v'] ] [data['%>s']] [:bytes_sent] ||= 0
      @stat[data['%v'] ] [data['%>s']] [:bytes_sent] += data['%O'].to_i
    end
  end
  
  def get
    @stat.to_json
  end
end
end

  end
end
#TO CHECK - port not used
# apache log format configured, apache logger configured
# TODO apachelogregex - installed?
