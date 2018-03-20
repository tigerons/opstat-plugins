require 'logging.rb'
module Opstat
  module Plugins
    def self.load_models
      pwd  = File.dirname(File.expand_path(__FILE__))
      Dir.glob(File.expand_path("#{pwd}/app/models/*.rb")).each do |file|
puts "loading #{file}"
        filename = File.basename(file, '.*')
        class_name_symbol = filename.classify.to_sym
        #autoload class_name_symbol, "#{pwd}/app/models/#{filename}"
        require "#{pwd}/app/models/#{filename}"
      end
    end

    def self.load_parsers(oplogger)
      pwd  = File.dirname(File.expand_path(__FILE__))
      parsers = {}
      Dir.glob(File.expand_path("#{pwd}/parsers/*.rb")).each do |file|
        require file
	plugin_name = File.basename(file,'.*')
	plugin_class = "Opstat::Parsers::#{plugin_name.capitalize}"
	oplogger.info "loading parser #{plugin_name}"
        parsers[plugin_name] ||= Opstat::Common.constantize(plugin_class).new 
      end
      return parsers
    end

    def self.load_parser(name)
      pwd  = File.dirname(File.expand_path(__FILE__))
      require pwd + "/parsers/#{name}.rb"
    end

    def self.load_plugin(name)
      pwd  = File.dirname(File.expand_path(__FILE__))
      require pwd + "/plugins/#{name}.rb"
    end
    module Models
      attr_reader :data_type
      def data_type(type)
        @data_type = type
      end
    end
  end
end
