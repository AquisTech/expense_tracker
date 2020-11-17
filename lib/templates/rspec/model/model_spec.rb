<% require "#{Rails.root}/app/models/#{singular_table_name}.rb" -%>
<% attributes_names = class_name.constantize.columns_hash -%>
require 'rails_helper'

<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
  let(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }

  it 'has a valid factory' do
    expect(<%= singular_table_name %>).to be_valid
  end

  describe 'database columns' do
<% attributes_names.each do |attr, value| -%>
<% options = ['default', 'null', 'limit', 'precision', 'scale'].map{ |o| "#{o}: #{value.send(o)}" unless value.send(o).nil? }.compact.join(", ") -%>
<% options_spec = ".with_options(#{options})" -%>
    it { should have_db_column(:<%= attr %>).of_type(:<%= value.type %>)<%= options_spec %> }
<% end -%>
  end

  describe 'database indexes' do
<% ActiveRecord::Base.connection.indexes(class_name.constantize.table_name).each do |index_details| -%>
    it { should have_db_index(<%= index_details.columns.size == 1 ? ":#{index_details.columns.first}" : index_details.columns.map(&:to_sym) %>).unique(<%= index_details.unique %>) }
<% end -%>
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