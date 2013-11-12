require 'logger'

module Rack
  class CustomLogger
    def initialize(app,  custom_logger, level = ::Logger::INFO, custom_logger_formatter=nil)
      @app, @custom_logger, @level, @custom_logger_formatter = app, custom_logger, level, custom_logger_formatter
    end

    def call(env)
      logger = @custom_logger

      if @custom_logger_formatter
        logger.formatter = @custom_logger_formatter
      end

      logger.level = @level

      env['rack.logger'] = logger
      @app.call(env)
    end
  end

end
