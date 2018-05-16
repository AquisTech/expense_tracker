module ApplicationHelper
  def hide_if(condition)
    :hide if condition
  end

  def zf_class_for flash_type
    { success: 'success', error: 'alert', failure: 'alert', alert: 'warning', notice: 'primary' }[flash_type.to_sym]
  end

  def flash_messages
    flash.map do |msg_type, message|
      content_tag(:div, class: "callout #{zf_class_for(msg_type)}", data: { closable: true }) do
        (button_tag(type: 'button', class: 'close-button', data: { close: true }) do
          content_tag(:span, '&times;'.html_safe)
        end + message).html_safe
      end
    end.join.html_safe
  end

  def flash_messages_with_grid_container
    content_tag(:div, class: 'grid-container') do
      flash_messages
    end
  end

  def close_reveal_button(text = 'Cancel')
    content_tag(:div, text, class: 'button warning', data: {close: ''})
  end
end