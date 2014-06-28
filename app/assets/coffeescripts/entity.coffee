window.Entity = 
  reverseUrlTrigger: (type, id) ->
    $(".loading").html("处理中...")
    $(".loading").removeClass("hidden")
    $.ajax
      url: "/entity/reverse_url_trigger"
      type: "get"
      data: {type: type, id: id}
      success: (data) ->
        console.log(data)
        data = eval("(" + data + ")") if typeof(data) == "string"
        console.log(data)
        $(".alert").addClass("hidden")
        if data.code == 1
          $(".alert-success").html("执行成功 - 返回信息:" + data.info)
          $(".alert-success").removeClass("hidden")
        else
          $(".alert-danger").html("执行失败- 返回信息:" + data.info)
          $(".alert-danger").removeClass("hidden")
        $(".loading").addClass("hidden")
