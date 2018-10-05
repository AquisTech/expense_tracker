module ActiveRecord::MysqlExtension

  extend ActiveSupport::Concern

  class_methods do
    def DAY(attr)
      "DAY(#{attr})"
    end

    def DATE_DIFF(date1, date2)
      "DATEDIFF(#{date1}, #{date2})"
    end

    def DAY_OF_WEEK(attr)
      "DAYOFWEEK(#{attr})"
    end

    def DAY_OF_MONTH(attr)
      "IF(#{LAST_DAY(attr)} = :date, -1, #{DAY(attr)})"
    end

    def WEEK_OF_MONTH(attr)
      "IF(#{WEEK(attr)} - WEEK(#{LAST_DAY(attr)}, 2) = 0, -1, (#{WEEK(attr)} - WEEK(:date - INTERVAL #{DAY(attr)} - 1 DAY, 2) + 1))"
    end

    def LAST_DAY(attr)
      "LAST_DAY(#{attr})"
    end

    def WEEK(attr)
      "WEEK(#{attr}, 2)"
    end

    def MONTH(attr)
      "MONTH(#{attr})"
    end

    def PERIOD_DIFF_IN_MONTHS(date1, date2)
      "PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM #{date1}), EXTRACT(YEAR_MONTH FROM #{date2}))"
    end

    def PERIOD_DIFF_IN_YEARS(date1, date2)
      "PERIOD_DIFF(EXTRACT(YEAR FROM #{date1}), EXTRACT(YEAR FROM #{date2}))"
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::MysqlExtension) if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
