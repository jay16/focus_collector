(function() {
  window.App = {
    showLoading: function() {
      return $(".loading").removeClass("hidden");
    },
    hideLoading: function() {
      return $(".loading").addClass("hidden");
    },
    api_demo: function(id) {
      return $.ajax({
        type: "get",
        url: "url",
        data: {
          "id": id
        },
        dataType: "json",
        success: function(data) {
          return console.log(data);
        },
        error: function() {
          return alert("error:get with ajax!");
        }
      });
    }
  };

}).call(this);
