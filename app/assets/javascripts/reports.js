// Activate spreadsheet library
$(document).ready(function () {
  $.fn.calculateFields = function () {
    var element = $(this),
      footer = element.find('tfoot tr'),
      price = element.find('.price'),
      totalProduct = element.find('.total-product'),
      dataRows = element.find('tbody tr');

    initialTotal = function () {
      var column, total;
      for (column = 1; column < footer.children().length; column++) {
        total = 0;
        dataRows.each(function () {
          var row = $(this);
          total += parseFloat(row.children().eq(column).text());
        });
        footer.children().eq(column).text(total);
      };
    };

    // element.find('td').on('change', function (evt) {
    //   var cell = $(this),
    //     column = cell.index(),
    //     total = 0;
    //   if (column === 0) {
    //     return;
    //   }
    //   element.find('tbody tr').each(function () {
    //     var row = $(this);
    //     total += parseFloat(row.children().eq(column).text());
    //   });
    //   if (column === 1 && total > 5000) {
    //     $('.alert').show();
    //     return false; // changes can be rejected
    //   } else {
    //     $('.alert').hide();
    //     footer.children().eq(column).text(total);
    //   }
    // });

    initialTotal();
    return this;
  };

  $('#mainTable').editableTableWidget().calculateFields();
});

// Send new changes to database
// $('#editable td').on('change', function(evt, newValue) {
// });
