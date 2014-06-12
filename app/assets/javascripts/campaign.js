(function() {
  window.Campaign = {
    add_column: function() {
      var colnum, new_column;
      colnum = $(".campaign-column").length;
      colnum += 1;
      new_column = '<div class="form-group campaign-column new-column-' + colnum + '" data-index="' + colnum + '">';
      new_column += '  <label for="name" style="min-width:55px;">字段 ' + colnum + ' </label>';
      new_column += '  <input class="form-control" name="campaign[column' + colnum + ']" placeholder="column' + colnum + '" style="width:60%;display:inline;" type="text" value="">';
      new_column += '  <a class="btn btn-default btn-sm btn-danger" href="javascript:void(0);" onclick="Campaign.remove_column(this,' + colnum + ');">移除</a>';
      new_column += '</div>';
      $(".campaign-column a").attr("disabled", "disabled");
      $("#campaign_form .form-group").last().after(new_column);
      return $("input[name='campaign[colnum]']").val(colnum);
    },
    remove_column: function(self, index) {
      var $this, pre_index;
      $this = $(self).parent(".campaign-column").first();
      index = parseInt($this.data("index"));
      pre_index = index - 1;
      $(".new-column-" + pre_index + " a").removeAttr("disabled");
      $("input[name='campaign[colnum]']").val(pre_index);
      return $this.remove();
    }
  };

}).call(this);
