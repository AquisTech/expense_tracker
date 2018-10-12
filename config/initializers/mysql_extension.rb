module ActiveRecord::MysqlExtension

  extend ActiveSupport::Concern

  class_methods do
    def DAY(attr)
      "DAY(#{attr})"
    end

    def LAST_DAY(attr)
      "LAST_DAY(#{attr})"
    end

    def DATE_DIFF(date1, date2)
      "DATEDIFF(#{date1}, #{date2})"
    end

    def DAY_OF_WEEK(attr)
      "DAYOFWEEK(#{attr})"
    end

    def DAY_OF_MONTH(attr)
      "#{DAY(attr)}, IF(#{LAST_DAY(attr)} = #{attr}, -1, NULL)"
    end

    def WEEK(attr)
      "WEEK(#{attr}, 2)"
    end

    def WEEK_OF_FIRST_DAY_OF_MONTH(attr)
      "WEEK(#{attr} - INTERVAL #{DAY(attr)} - 1 DAY, 2)"
    end

    def WEEK_OF_LAST_DAY_OF_MONTH(attr)
      "WEEK(#{LAST_DAY(attr)}, 2)"
    end

    def WEEK_OF_MONTH(attr)
      "(#{WEEK(attr)} - #{WEEK_OF_FIRST_DAY_OF_MONTH(attr)} + 1), IF(#{WEEK(attr)} - #{WEEK_OF_LAST_DAY_OF_MONTH(attr)} = 0, -1, NULL)"
    end

    def MONTH(attr)
      "MONTH(#{attr})"
    end

    def PERIOD_DIFF_IN_MONTHS(end_date, start_date)
      "PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM #{end_date}), EXTRACT(YEAR_MONTH FROM #{start_date}))"
    end

    def PERIOD_DIFF_IN_YEARS(end_date, start_date)
      "PERIOD_DIFF(EXTRACT(YEAR FROM #{end_date}), EXTRACT(YEAR FROM #{start_date}))"
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::MysqlExtension) if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
