module ApplicationHelper
  def hide_if(condition)
    :hide if condition
  end

  def invite_for_registration_via_whatsapp
    url = build_whatsapp_url("Hey Buddy! Join me on MoneyBee, an expense tracking, budgeting and finance planning app. #{new_user_registration_url}")
    link_to 'Invite via WhatsApp', url, class: 'button success hollow'
  end

  def build_whatsapp_url(message, recipient = nil)
    "https://wa.me/#{(recipient + '/') if recipient}?text=#{URI.encode(message)}"
  end

end