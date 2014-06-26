(function() {
  window.Template = {
    inputWhetherRequired: function() {
      var isDisabled;
      isDisabled = false;
      $("input").each(function() {
        if ($(this).hasClass("required")) {
          if (!$(this).val().length) {
            return isDisabled = true;
          }
        }
      });
      if (isDisabled === true) {
        return $("#templateSubmit").attr("disabled", "disabled");
      } else {
        return $("#templateSubmit").removeAttr("disabled");
      }
    },
    ajax: function(json, feedback) {
      return $.ajax({
        url: "/entity",
        type: "get",
        data: json,
        success: function(data) {
          if (typeof data === "string") {
            data = eval('(' + data + ')');
          }
          $("form").addClass("hidden");
          $(".alert-success").removeClass("hidden");
          if (data.code === 200) {
            return $(".alert-success").html(feedback);
          } else {
            return $(".alert-success").html(data.code + " - " + data.info);
          }
        }
      });
    },
    submit: function(token, feedback) {
      var columns, json_str;
      columns = new Array();
      $("input").each(function() {
        var column, value;
        column = $(this).data("column");
        value = $(this).val();
        return columns.push('"' + column + '": "' + value + '"');
      });
      columns.push('"token": "' + token + '"');
      json_str = "{" + columns.join(",") + "}";
      return Template.ajax(JSON.parse(json_str), feedback);
    }
  };

  $(function() {
    Template.inputWhetherRequired();
    return $("input").bind("change keyup input", function() {
      if ($(this).hasClass("required")) {
        return Template.inputWhetherRequired();
      }
    });
  });

}).call(this);
