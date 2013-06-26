module SQLOrigin
  # @private
  module LogHook
    def log(sql, name = "SQL", binds = [])
      @instrumenter.instrument(
          "sql.active_record",
          :sql           => sql,
          :name          => name,
          :connection_id => object_id,
          :binds         => binds,
          :backtrace     => SQLOrigin.filtered_backtrace[0, 3]) { yield }
    rescue Exception => e
      message = "#{e.class.name}: #{e.message}: #{sql}"
      @logger.debug message if @logger
      exception = translate_exception(e, message)
      exception.set_backtrace e.backtrace
      raise exception
    end
  end

  # @private
  module LogSubscriber
    extend ActiveSupport::Concern
    included { alias_method_chain :sql, :backtrace }

    def sql_with_backtrace(event)
      return unless sql_without_backtrace(event)
      return unless event.payload[:backtrace]

      if event.payload[:backtrace].any?
        event.payload[:backtrace].each do |line|
          debug "    #{color line, "\e[90m", false}"
        end
      end
    end
  end

  # @private
  module QueryAppendHook
    extend ActiveSupport::Concern
    included { alias_method_chain :execute, :backtrace }

    def execute_with_backtrace(sql, name=nil)
      if (line = SQLOrigin.filtered_backtrace.first)
        execute_without_backtrace "#{sql} /* #{line} */", name
      else
        execute_without_backtrace sql, name
      end
    end
  end
end
