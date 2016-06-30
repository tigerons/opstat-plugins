require 'log4r'

module Opstat
module Logging
  def preconfig_logger
    return @logger if @logger
    @logger = Log4r::Logger.new self.class.to_s
    @logger.level = @logger.levels.index('INFO')
    outputter = Log4r::Outputter.stdout
    outputter.formatter = Log4r::PatternFormatter.new(:pattern => "%l - %C - %m")
    @logger.outputters << outputter
    @logger
  end
  def oplogger
    return @logger if @logger
    @logger = Log4r::Logger.new self.class.to_s
    @logger.level = @logger.levels.index(log_level)
    outputter = Log4r::Outputter.stdout
    outputter.formatter = Log4r::PatternFormatter.new(:pattern => "%l - %C - %m")
    @logger.outputters << outputter
    @logger
  end
  def log_level
    @log_level ||= Opstat::Config.instance.get('client')['log_level']
    @log_level
  end
end
end

