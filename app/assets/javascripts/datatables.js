//= require datatables/jquery.dataTables

// optional change '//' --> '//=' to enable

// require datatables/extensions/AutoFill/dataTables.autoFill
// require datatables/extensions/Buttons/dataTables.buttons
// require datatables/extensions/Buttons/buttons.html5
// require datatables/extensions/Buttons/buttons.print
// require datatables/extensions/Buttons/buttons.colVis
// require datatables/extensions/Buttons/buttons.flash
// require datatables/extensions/ColReorder/dataTables.colReorder
// require datatables/extensions/FixedColumns/dataTables.fixedColumns
// require datatables/extensions/FixedHeader/dataTables.fixedHeader
// require datatables/extensions/KeyTable/dataTables.keyTable
// require datatables/extensions/Responsive/dataTables.responsive
// require datatables/extensions/RowGroup/dataTables.rowGroup
// require datatables/extensions/RowReorder/dataTables.rowReorder
// require datatables/extensions/Scroller/dataTables.scroller
// require datatables/extensions/Select/dataTables.select

//= require datatables/dataTables.foundation
// require datatables/extensions/AutoFill/autoFill.foundation
// require datatables/extensions/Buttons/buttons.foundation
// require datatables/extensions/Responsive/responsive.foundation


//Global setting and initializer

$.extend( $.fn.dataTable.defaults, {
  responsive: true,
  retrieve: true,
  processing: true,
  serverSide: true,
  pagingType: 'full_numbers',
  ajax: {
    type: 'POST',
    data: { authenticity_token: $('meta[name=csrf-token]').attr('content') }
  },
  //dom:
  //  "<'row'<'col-sm-4 text-left'f><'right-action col-sm-8 text-right'<'buttons'B> <'select-info'> >>" +
  //  "<'row'<'dttb col-12 px-0'tr>>" +
  //  "<'row'<'col-sm-12 table-footer'lip>>"
});

$(document).on('preInit.dt', function(e, settings) {
  var api, table_id, url;
  api = new $.fn.dataTable.Api(settings);
  table_id = "#" + api.table().node().id;
  url = $(table_id).data('source');
  if (url) {
    return api.ajax.url(url);
  }
});

// init on turbolinks load
// This is commented as we are not using this to initialize all tables using data attributes in HTML on <th>
// If you want to use this then you will need to add data attributes on <th> for searchable and sortable
// Current implementation maintains all columns configs for serachable and sortable at a single place
// in app/datatables/*_datatable.rb
// $(document).on('turbolinks:load', function() {
//   if (!$.fn.DataTable.isDataTable("table[id^=dttb-]")) {
//     $("table[id^=dttb-]").DataTable();
//   }
// });

// turbolinks cache fix
$(document).on('turbolinks:before-cache', function() {
  var dataTable = $($.fn.dataTable.tables(true)).DataTable();
  if (dataTable !== null) {
    dataTable.clear();
    dataTable.destroy();
    return dataTable = null;
  }
});
