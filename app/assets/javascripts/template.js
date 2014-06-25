(function() {
  window.Template = {
    inputWhetherRequired: function() {
      var isDisabled;
      isDisabled = false;
      $("input").each(function() {
        if ($(this).hasClass("required")) {
          console.log($(this).val().length);
          if (!$(this).val().length) {
            return isDisabled = true;
          }
        }
      });
      if (isDisabled === true) {
        $("#templateSubmit").attr("disabled", "disabled");
      } else {
        $("#templateSubmit").removeAttr("disabled");
      }
      return console.log(isDisabled);
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
