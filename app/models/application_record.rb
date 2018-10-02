class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def mysql?
    ActiveRecord::Base.connection.adapter_name = 'Mysql2'
  end

  def pg?
    ActiveRecord::Base.connection.adapter_name = 'PostgreSQL'
  end
end
