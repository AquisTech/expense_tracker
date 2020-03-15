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
      "(DATE(#{date1}) - DATE(#{date2}))"
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

    def PERIOD_DIFF_IN_MONTHS(end_date, start_date)
      "#{PERIOD_DIFF_IN_YEARS(end_date, start_date)} * 12 + (DATE_PART('month', DATE(#{end_date})) - DATE_PART('month', #{start_date}))::INTEGER"
    end

    def PERIOD_DIFF_IN_YEARS(end_date, start_date)
      "DATE_PART('year', DATE(#{end_date})) - DATE_PART('year', #{start_date})::INTEGER"
    end

    def INTERVAL_COLUMN
      "occurrences.interval"
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::PostgreSQLExtension) if Rails.const_defined?('Server') && ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
