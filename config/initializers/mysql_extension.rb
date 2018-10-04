module ActiveRecord::MysqlExtension

  extend ActiveSupport::Concern

  class_methods do
    def DAY(attr)
      "DAY(#{attr})"
    end

    def DATEDIFF(date1, date2)
      "DATEDIFF(#{date1}, #{date2})"
    end

    def DAYOFWEEK(attr)
      "DAYOFWEEK(#{attr})"
    end

    def LAST_DAY(attr)
      "LAST_DAY(#{attr})"
    end

    def WEEK(attr, n)
      "WEEK(#{attr}, #{n})"
    end

    def MONTH(attr)
      "MONTH(#{attr})"
    end

    def PERIOD_DIFF
      ""
      ""
    end

    def PERIOD_DIFF_IN_MONTHS()
      ""
      ""
    end

    def PERIOD_DIFF_IN_YEARS()
      ""
      ""
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::MysqlExtension) if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
