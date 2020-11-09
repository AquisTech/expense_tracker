class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegator :@view, :link_to_actions

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def js_view_columns
    view_columns.map{ |col_key, col_config| col_config.merge(data: col_key) }.to_json
  end
end