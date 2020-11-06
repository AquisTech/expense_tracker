class <%= datatable_name %> < ApplicationDatatable

  <%- attributes = name.classify.constantize.column_names -%>
  def view_columns
    @view_columns ||= {
    <%- attributes.each do |attr| -%>
      <%= attr %>: { source: '<%= name.classify %>.<%= attr %>' },
    <%- end -%>
    }
  end

  def data
    records.map do |record|
      {
      <%- attributes.each do |attr| -%>
        <%= attr %>: record.<%= attr %>,
      <%- end -%>
        DT_RowId: record.id,
      }
    end
  end

  def get_raw_records
    <%= name.classify %>.all
  end

end