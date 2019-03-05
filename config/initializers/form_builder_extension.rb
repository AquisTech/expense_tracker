class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def amount_field(method, options={})
    classes = options[:class] || ''
    classes.concat(classes.is_a?(Array) ? ['input-group-field'] : ' input-group-field')
    options[:class] = classes
    options[:min] = options[:min] || 0
    options[:value] = self.object.try(:send, method) || options[:value] || 0
    content_tag :div, class: 'input-group' do
      content_tag(:span, options[:currency].html_safe || '$', class: "input-group-label input-group-inset #{options[:sign]}") + # TODO: Currency as per user preference
      number_field(method, options)
    end.html_safe
  end

  def awesomplete_select(method, collection, method_for_value, method_for_text, options={})
    (
      text_field("#{method}_search", id: "#{method}_awesomplete", data: { list: "##{method}_list" }.merge(options)) +
      content_tag(:datalist, id: "#{method}_list") do
        collection.map do |member|
          content_tag(:option, member.send(method_for_text), value: member.send(method_for_value))
        end.join.html_safe
      end +
      hidden_field(method, id: "#{method}_awesomplete_value") +
      raw("<script>new Awesomplete(document.getElementById('#{method}_awesomplete'), {list: '##{method}_list', replace: function(suggestion) { this.input.value = suggestion.label; document.getElementById('#{method}_awesomplete_value').value = suggestion.value; }});</script>")
    )
  end
end
