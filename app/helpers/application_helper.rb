module ApplicationHelper
  include Pagy::Frontend

  def hide_if(condition)
    :hide if condition
  end

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

  def close_reveal_button(text = 'Cancel')
    content_tag(:div, text, class: 'button warning', data: {close: ''})
  end

  def add_new_button(content, url)
    link_to_reveal(content, url, 'button primary float-right margin-top-1')
  end

  def link_to_reveal(content, url, classes)
    link_to content, 'javascript:void(0)', class: classes, data: {open: 'ajax-reveal', url: url}
  end

  def link_to_edit(object)
    link_to_reveal 'Edit', url_for(action: :edit, id: object), 'button primary'
  end

  def link_to_edit_icon(object)
    link_to_reveal 'Edit', url_for(action: :edit, id: object), 'button clear warning' # TODO : icon_tag('create')
  end

  def link_to_show_icon(object)
    link_to_reveal 'Show', url_for(object), 'button clear success' # TODO : icon_tag('visibility')
  end

  def link_to_delete_icon(object)
    link_to 'Delete', object, method: :delete, data: { confirm: "Are you sure you want to delete this #{object.class.name}?" }, class: 'button clear alert' # TODO : icon_tag('delete')
  end

  def invite_for_registration_via_whatsapp
    url = build_whatsapp_url("Hey Buddy! Join me on MoneyBee, an expense tracking, budgeting and finance planning app. #{new_user_registration_url}")
    link_to 'Invite via WhatsApp', url, class: 'button success hollow'
  end

  def build_whatsapp_url(message, recipient = nil)
    "https://wa.me/#{(recipient + '/') if recipient}?text=#{URI.encode(message)}"
  end

end