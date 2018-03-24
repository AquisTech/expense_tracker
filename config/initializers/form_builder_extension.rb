class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def amount_field(method, options={})
    classes = options[:class] || ''
    classes.concat(classes.is_a?(Array) ? ['input-group-field'] : ' input-group-field')
    options[:class] = classes
    options[:min] = options[:min] || 0
    options[:value] = options[:value] || 0 # TODO: Check for value of persisted object
    content_tag :div, class: 'input-group' do
      content_tag(:span, options[:currency].html_safe || '$', class: 'input-group-label') +
      number_field(method, options)
    end.html_safe
  end
end
