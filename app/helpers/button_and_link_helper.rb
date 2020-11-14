module ButtonAndLinkHelper
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

  def link_to_actions(object)
    link_to_show_icon(object) + link_to_edit_icon(object) + link_to_delete_icon(object)
  end
end