<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
  # Validations
  <%- attributes_names = attributes.empty? ? singular_table_name.classify.constantize.columns_hash.except('id', 'created_at', 'updated_at') : attributes -%>
<% attributes_names.each do |attr, value| -%>
<% next if attr.ends_with?('_id') -%>
  validates :<%= attr %>, presence: true<%- if value.type == :integer -%>
, numericality: { only_integer: true }
<%- elsif value.type == :float -%>
, numericality: true
<%- elsif value.type == :boolean -%>
, inclusion: { in: [true, false] }
<%- elsif value.type == :text -%>
<%- elsif value.type == :string -%>
<%- elsif value.type == :date -%>
<%- elsif value.type == :datetime -%>
<%- end -%><%- if attr.ends_with?('_confirmation') -%>
, confirmation: true
<%- end %>
<% end -%>
  # Callbacks

  # Associations
<%- belongs_to_attrs = attributes_names.select{ |attr, value| attr.ends_with?('_id') } -%>
<% belongs_to_attrs.each do |attr, value| -%>
  belongs_to :<%= attr.gsub(/_id$/, '') %><%= ', polymorphic: true' if attributes_names.keys.include?(attr.gsub(/_id$/, '_type')) %>
<% end -%>
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %>
<% end -%>

<% attributes.select(&:token?).each do |attribute| -%>
  has_secure_token<% if attribute.name != "token" %> :<%= attribute.name %><% end %>
<% end -%>
<% if attributes.any?(&:password_digest?) -%>
  has_secure_password
<% end -%>
end
<% end -%>