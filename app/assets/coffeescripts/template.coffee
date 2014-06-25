window.Template = 
  inputWhetherRequired: ->
    isDisabled = false
    $("input").each ->
      if($(this).hasClass("required"))
        console.log($(this).val().length)
        isDisabled = true if(!$(this).val().length) 

    if(isDisabled == true) 
      $("#templateSubmit").attr("disabled", "disabled")
    else
      $("#templateSubmit").removeAttr("disabled")

    console.log(isDisabled)

$ ->
  Template.inputWhetherRequired()
  $("input").bind "change keyup input", ->
    Template.inputWhetherRequired() if($(this).hasClass("required"))
