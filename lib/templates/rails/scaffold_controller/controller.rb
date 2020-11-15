<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  def index
  end

  def datatable
    render json: <%= controller_class_name %>Datatable.new(params, view_context: view_context)
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    render layout: false
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    if @<%= orm_instance.save %>
      redirect_to <%= index_helper %>_path, notice: <%= "'#{human_name} was successfully created.'" %>
    else
      render_failure(@<%= singular_table_name %>)
    end
  end

  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to <%= index_helper %>_path, notice: <%= "'#{human_name} was successfully updated.'" %>
    else
      render_failure(@<%= singular_table_name %>)
    end
  end


  def destroy
    if @<%= orm_instance.destroy %>
      redirect_to <%= index_helper %>_path, notice: <%= "'#{human_name} was successfully destroyed.'" %>
    else
      redirect_to <%= index_helper %>_path, notice: <%= "'#{human_name} could not be destroyed.'" %>
    end
  end

  private
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    def <%= "#{singular_table_name}_params" %>
      <%- attributes_names = attributes.empty? ? singular_table_name.classify.constantize.column_names - ['id', 'created_at', 'updated_at'] : attributes -%>
      <%- if attributes_names.empty? -%>
      params.fetch(:<%= singular_table_name %>, {})
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
