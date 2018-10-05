module ActiveRecord::PostgreSQLExtension

  extend ActiveSupport::Concern

  class_methods do
    def DAY(attr)
      "EXTRACT(DAY FROM DATE(#{attr}))"
    end

    def DATE_DIFF(date1, date2) # dasherize
      "DATE_PART('day', DATE(#{date1}) - #{date2})"
    end

    def DAY_OF_WEEK(attr) # dasherize
      "EXTRACT(DOW FROM DATE(#{attr}))"
    end

    def DAY_OF_MONTH(attr)

    end

    def WEEK_OF_MONTH(attr)

    end

    def LAST_DAY(attr)
      "(DATE_TRUNC('MONTH', DATE(#{attr})) + INTERVAL '1 MONTH - 1 DAY')::DATE"
    end

    def WEEK(attr)
      "EXTRACT(WEEK FROM DATE(#{attr}))"
    end

    def MONTH(attr)
      "EXTRACT(MONTH FROM DATE(#{attr}))"
    end

    def PERIOD_DIFF_IN_MONTHS(date1, date2)
      "PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM #{date1}), EXTRACT(YEAR_MONTH FROM #{date2})) % `interval` = 0"
    end

    def PERIOD_DIFF_IN_YEARS(date1, date2)
      "PERIOD_DIFF(EXTRACT(YEAR FROM #{date1}), EXTRACT(YEAR FROM #{date2})) % `interval` = 0"
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::PostgreSQLExtension) if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
