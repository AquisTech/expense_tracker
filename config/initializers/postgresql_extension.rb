module ActiveRecord::PostgreSQLExtension

  extend ActiveSupport::Concern

  class_methods do
    def DAY(attr)
      "EXTRACT(DAY FROM DATE(#{attr}))"
    end

    def DATEDIFF(date1, date2)
      "DATE_PART('day', DATE(#{date1}) - #{date2})"
    end

    def DAYOFWEEK(attr)
      "EXTRACT(DOW FROM DATE(#{attr}))"
    end

    def LAST_DAY(attr)
      "(DATE_TRUNC('MONTH', DATE(#{attr})) + INTERVAL '1 MONTH - 1 DAY')::DATE"
    end

    def WEEK(attr, n)
      "EXTRACT(WEEK FROM DATE(#{attr}))"
    end

    def MONTH(attr)
      "EXTRACT(MONTH FROM DATE(#{attr}))"
    end

    def PERIOD_DIFF
      ""
    end

    def PERIOD_DIFF_IN_MONTHS()
      ""
    end

    def PERIOD_DIFF_IN_YEARS()
      ""
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::PostgreSQLExtension) if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
