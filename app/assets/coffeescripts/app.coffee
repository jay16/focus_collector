window.App =
  showLoading :->
    $(".loading").removeClass("hidden")
  hideLoading :->
    $(".loading").addClass("hidden")

  api_demo: (id) ->
    $.ajax(
      type: "get"
      url: "url"
      data: { "id": id }
      dataType: "json"
      success: (data) ->
        console.log(data)
      error: ->
        alert("error:get with ajax!")
    );
