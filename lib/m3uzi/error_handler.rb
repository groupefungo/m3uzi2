require 'logger'

# Simply error handling and logging.
module ErrorHandler
  class << self
    attr_writer :logger
    def logger
      @logger ||= Logger.new($stdout)
    end

    # ==== Description
    # Set how the reader deals with errors. :warn logs a warning,
    # :fail will cause an error
    #
    # +val+ :: MUST be a symbol, either :warn (default) or :fail
    def failure_method=(val)
      @_failure_method = val if %w(:warn :fail).include(val)
    end

    def failure_method
      @_failure_method ||= :warn
    end

    def handle_error(message, force_fail = false)
      fail(message) if failure_method == :fail || force_fail
      logger.info message
    end
  end

  def self.included(base)
    class << base
      def logger
        ErrorHandler.logger
      end

      def failure_method
        ErrorHandler.failure_method
      end

      def handle_error(message, force_fail = false)
        ErrorHandler.handle_error(message, force_fail)
      end
    end
  end

  def failure_method
    ErrorHandler.failure_method
  end

  def handle_error(message, force_fail = false)
    ErrorHandler.handle_error(message, force_fail)
  end

  def logger
    Logging.logger
  end
end
