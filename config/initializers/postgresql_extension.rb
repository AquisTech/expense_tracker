module ActiveRecord::PostgreSQLExtension

  extend ActiveSupport::Concern

  class_methods do
    def CASE_WHEN(condition, truthy_result, falsey_result)
      "(CASE WHEN(#{condition}) THEN #{truthy_result} ELSE #{falsey_result} END)"
    end

    def DAY(attr)
      "EXTRACT(DAY FROM DATE(#{attr}))"
    end

    def LAST_DAY(attr)
      "(DATE_TRUNC('MONTH', DATE(#{attr})) + INTERVAL '1 MONTH - 1 DAY')::DATE"
    end

    def DATE_DIFF(date1, date2)
      "DATE_PART('day', DATE(#{date1}) - #{date2})"
    end

    def DAY_OF_WEEK(attr)
      "EXTRACT(DOW FROM DATE(#{attr}))"
    end

    def DAY_OF_MONTH(attr)
      "#{DAY(attr)}, #{CASE_WHEN("#{LAST_DAY(attr)} = #{attr}", -1, 'NULL')}"
    end

    def WEEK(attr)
      "EXTRACT(WEEK FROM DATE(#{attr}))"
    end

    def WEEK_OF_FIRST_DAY_OF_MONTH(attr)
      "EXTRACT(WEEK FROM DATE(#{attr}) - (#{DAY(attr)} - 1 || ' DAY')::INTERVAL)"
    end

    def WEEK_OF_LAST_DAY_OF_MONTH(attr)
      "EXTRACT(WEEK FROM #{LAST_DAY(attr)})"
    end

    def WEEK_OF_MONTH(attr)
      "(#{WEEK(attr)} - #{WEEK_OF_FIRST_DAY_OF_MONTH(attr)} + 1), #{CASE_WHEN("#{WEEK(attr)} - #{WEEK_OF_LAST_DAY_OF_MONTH(attr)} = 0", -1, 'NULL')}"
    end

    def MONTH(attr)
      "EXTRACT(MONTH FROM DATE(#{attr}))"
    end

    def PERIOD_DIFF_IN_MONTHS(date1, date2)
      "PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM #{date1}), EXTRACT(YEAR_MONTH FROM #{date2}))"
    end

    def PERIOD_DIFF_IN_YEARS(date1, date2)
      "PERIOD_DIFF(EXTRACT(YEAR FROM #{date1}), EXTRACT(YEAR FROM #{date2}))"
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::PostgreSQLExtension) if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
