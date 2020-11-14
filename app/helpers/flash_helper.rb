module FlashHelper
  def zf_class_for flash_type
    { success: 'success', error: 'alert', failure: 'alert', alert: 'warning', notice: 'primary' }[flash_type.to_sym]
  end

  def flash_messages
    flash.map do |msg_type, message|
      next unless zf_class_for(msg_type)
      content_tag(:div, class: "flash-message callout border-none radius shadow #{zf_class_for(msg_type)}", data: { closable: '' }) do
        (button_tag(type: 'button', class: 'close-button', data: { close: '' }) do
          content_tag(:span, '&times;'.html_safe)
        end + content_tag(:span, message, class: "text-#{zf_class_for(msg_type)}")).html_safe
      end
    end.join.html_safe
  end
end