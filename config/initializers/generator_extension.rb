module GeneratorExtension
  def field_type(name, type)
    return field_type_by_name(name) if name =~ /amount|email/
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

  def field_type_by_name(name)
    case name
    when /amount/  then :amount_field
    when /email/   then :email_field
    end
  end
end
Rails::Generators::NamedBase.include(GeneratorExtension)
