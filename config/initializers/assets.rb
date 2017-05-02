# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

module GeneratorExtension
  def field_type(type)
    case type
    when :integer              then :number_field
    when :float, :decimal      then :text_field
    when :time                 then :time_select
    when :datetime, :timestamp then :datetime_select
    when :date                 then :date_select
    when :text                 then :text_area
    when :boolean              then :check_box
    else
         :text_field
    end
  end
end
Rails::Generators::NamedBase.include(GeneratorExtension)
