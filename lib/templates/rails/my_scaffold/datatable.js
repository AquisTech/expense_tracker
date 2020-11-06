jQuery(document).ready(function() {
  $('#<%= name.tableize %>-datatable').dataTable({
    processing: true,
    serverSide: true,
    ajax: {
      url: $('#<%= name.tableize %>-datatable').data('source'),
      type: 'POST'
    },
    pagingType: 'full_numbers',
    columns: [
    <%- attributes = name.classify.constantize.column_names -%>
    <%- attributes.each do |attr| -%>
      { data: '<%= attr %>' },
    <%- end -%>
    ]
  });
});