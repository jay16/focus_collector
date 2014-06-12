(function() {
  window.Campaign = {
    addColumn: function() {
      var colnum, new_column;
      colnum = $(".campaign-column").length;
      colnum += 1;
      new_column = '<div class="form-group campaign-column new-column-' + colnum + '" data-index="' + colnum + '">';
      new_column += '  <label for="name" style="min-width:55px;">字段 ' + colnum + '* </label>';
      new_column += '  <input class="form-control require column" onkeyup="Campaign.inputMonitor();" onchange="Campaign.inputMonitor();" oninput="Campaign.inputMonitor();" name="campaign[column' + colnum + ']" placeholder="column' + colnum + '" style="width:50%;display:inline;" type="text" value="">';
      new_column += '  <a class="btn btn-default btn-sm btn-danger" href="javascript:void(0);" onclick="Campaign.removeColumn(this,' + colnum + ');">移除</a>';
      new_column += '  <span class="alert alert-danger" style="display:inline;padding:5px;">不可为空;</span>';
      new_column += '</div>';
      $(".campaign-column a").attr("disabled", "disabled");
      $("#campaign_form .form-group").last().after(new_column);
      return $("input[name='campaign[colnum]']").val(colnum);
    },
    removeColumn: function(self, index) {
      var $this, pre_index;
      $this = $(self).parent(".campaign-column").first();
      index = parseInt($this.data("index"));
      pre_index = index - 1;
      $(".new-column-" + pre_index + " a").removeAttr("disabled");
      $("input[name='campaign[colnum]']").val(pre_index);
      $this.remove();
      return Campaign.inputMonitor();
    },
    inputMonitor: function() {
      var columns, disabled_submit, keywords;
      keywords = $("input[name='campaign[keywords]']").val().split(/,/);
      disabled_submit = false;
      columns = [];
      return $("#campaign_form").find(".require").each(function() {
        var $this, $warn, is_error, value, warn;
        $this = $(this);
        value = $.trim($this.val());
        $warn = $this.siblings(".alert-danger");
        is_error = false;
        warn = "";
        if (!value.length) {
          is_error = true;
        }
        if (is_error) {
          warn = "不可为空;";
        }
        if (value.length && $this.hasClass("column")) {
          if ($.inArray(value, keywords) >= 0) {
            is_error = true;
            warn += "关键字冲突;";
          }
          if ($.inArray(value, columns) >= 0) {
            is_error = true;
            warn += "字段名重复;";
          }
          columns.push(value);
        }
        if (is_error === true) {
          $warn.removeClass("hidden");
        } else {
          $warn.addClass("hidden");
        }
        $warn.html(warn);
        if (is_error) {
          disabled_submit = true;
        }
        if (disabled_submit === true) {
          return $("button[type='submit']").attr("disabled", "disabled");
        } else {
          return $("button[type='submit']").removeAttr("disabled");
        }
      });
    }
  };

  $(function() {
    Campaign.inputMonitor();
    return $("input").bind("change keyup input", function() {
      return Campaign.inputMonitor();
    });
  });

}).call(this);
