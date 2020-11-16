<% require "#{Rails.root}/app/models/#{singular_table_name}.rb" -%>
require 'rails_helper'

<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
  let(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }

  it "has a valid factory" do
    expect(<%= singular_table_name %>).to be_valid
  end

<% attributes_names = class_name.constantize.columns_hash.except('id', 'created_at', 'updated_at') -%>
  describe 'validations' do
<% attributes_names.each do |attr, value| -%>
<% next if attr.ends_with?('_id') -%>
<% next if attr.ends_with?('_type') && attributes_names.keys.include?(attr.gsub(/_type$/, '_id')) -%>
    it { should validate_presence_of(:<%= attr %>) }
<% end -%>
  end

  describe 'associations' do
<% class_name.constantize.reflections.each do |assoc, details| -%>
    it { should <%= {belongs_to: 'belong_to', has_one: 'have_one', has_many: 'have_many'}[details.macro] %>(:<%= assoc %>) }
<% end -%>
  end
end
<% end -%>