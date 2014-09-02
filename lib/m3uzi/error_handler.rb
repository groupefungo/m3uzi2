require 'logger'

module ErrorHandler
  class << self
    def logger
      @logger ||= Logger.new($stdout)
    end

    def logger=(logger)
      @logger = logger
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
    puts "INCLUDED"
    class << base
      def logger
        ErrorHandler.logger
      end

      def failure_method
        ErrorHandler.failure_method
      end

      def handle_error(message, force_fail = false)
        ErrorHandler.failure_method
      end
    end
  end

  def handle_error(message, force_fail = false)
    ErrorHandler.failure_method
  end
  #def logger
    #Logging.logger
  #end


end
