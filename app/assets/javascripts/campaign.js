(function() {
  window.Campaign = {
    add_column: function() {
      var colnum, new_column;
      colnum = $(".campaign-column").length;
      colnum += 1;
      new_column = '<div class="form-group campaign-column new-column">';
      new_column += '  <label for="name" style="min-width:55px;">字段 ' + colnum + ' </label>';
      new_column += '  <input class="form-control" name="campaign[column' + colnum + ']" placeholder="column' + colnum + '" style="width:60%;display:inline;" type="text" value="">';
      new_column += '  <a class="btn btn-default btn-sm btn-danger" href="">删除</a>';
      new_column += '</div>';
      $(".new-column a").attr("disabled", "disabled");
      return $("#campaign_form .form-group").last().append(new_column);
    }
  };

}).call(this);
