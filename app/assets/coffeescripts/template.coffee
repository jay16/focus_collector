window.Template = 
  inputWhetherRequired: ->
    isDisabled = false
    $("input").each ->
      if($(this).hasClass("required"))
        isDisabled = true if(!$(this).val().length) 

    if(isDisabled == true) 
      $("#templateSubmit").attr("disabled", "disabled")
    else
      $("#templateSubmit").removeAttr("disabled")


  ajax: (json, feedback) ->
    $.ajax
      url: "/entity" 
      type: "get"
      data: json
      success: (data) ->
        data = eval('(' + data + ')') if typeof(data) == "string"
        $("form").addClass("hidden")
        $(".alert-success").removeClass("hidden")
        if(data.code == 200)
          $(".alert-success").html(feedback)
        else
          $(".alert-success").html(data.code + " - " + data.info)

  submit: (token, feedback) ->
    columns = new Array()
    $("input").each ->
      column = $(this).data("column")
      value = $(this).val()
      columns.push('"' + column+'": "' + value + '"')
    columns.push('"token": "' + token + '"')
    json_str = "{" + columns.join(",") + "}"
    Template.ajax(JSON.parse(json_str), feedback)

$ ->
  Template.inputWhetherRequired()
  $("input").bind "change keyup input", ->
    Template.inputWhetherRequired() if($(this).hasClass("required"))
