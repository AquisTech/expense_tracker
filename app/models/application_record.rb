class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  unless Rails.env.prod?
    def self.seed_from_factory(count = 1)
      count.times do
        FactoryBot.create(self.to_s.underscore.to_sym)
      end
    end
  end
end
