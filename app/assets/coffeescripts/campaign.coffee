window.Campaign = 
  add_column: ->
    colnum = $(".campaign-column").length
    colnum += 1
    new_column = '<div class="form-group campaign-column new-column-' + colnum + '" data-index="' + colnum + '">'
    new_column += '  <label for="name" style="min-width:55px;">字段 ' + colnum + '* </label>'
    new_column += '  <input class="form-control require column" onkeyup="Campaign.input_monitor();" onchange="Campaign.input_monitor();" oninput="Campaign.input_monitor();" name="campaign[column' + colnum + ']" placeholder="column' + colnum + '" style="width:50%;display:inline;" type="text" value="">'
    new_column += '  <a class="btn btn-default btn-sm btn-danger" href="javascript:void(0);" onclick="Campaign.remove_column(this,' + colnum + ');">移除</a>'
    new_column += '  <span class="alert alert-danger" style="display:inline;padding:5px;">不可为空;</span>'
    new_column += '</div>'
    # 逆向删除！添加新的column后，之前添加的column不可删除
    $(".campaign-column a").attr("disabled", "disabled")
    $("#campaign_form .form-group").last().after(new_column)
    $("input[name='campaign[colnum]']").val(colnum);

  remove_column: (self, index) ->
    $this = $(self).parent(".campaign-column").first()
    index = parseInt($this.data("index"))
    pre_index = index - 1
    #删除自己前把前面新添的字段激活
    $(".new-column-"+pre_index+" a").removeAttr("disabled")
    #修改colnum
    $("input[name='campaign[colnum]']").val(pre_index);
    $this.remove()


  input_monitor: ->
    keywords = $("input[name='campaign[keywords]']").val().split(/,/)
    disabled_submit = false
    columns = []
    $("#campaign_form").find(".require").each ->
      $this = $(this)
      value = $.trim($this.val())
      $warn = $this.siblings(".alert-danger")
      #默认没有错误
      is_error = false
      warn = ""
      #name, column-n不可为空
      is_error = true if(!value.length)
      warn = "不可为空;" if(is_error)

      if value.length && $this.hasClass("column")
        #column-n不可以与关键字冲突
        if($.inArray(value, keywords)>=0)
          is_error = true
          warn += "关键字冲突;"
        #column-n不可重复
        if($.inArray(value, columns)>=0)
          is_error = true
          warn += "字段名重复;"

        columns.push(value)

      if(is_error==true) 
        $warn.removeClass("hidden") 
      else 
        $warn.addClass("hidden")

      $warn.html(warn)
      disabled_submit = true if(is_error) 

      #默认为false，有一个错误就设置为true
      if(disabled_submit==true) 
        $("button[type='submit']").attr("disabled","disabled") 
      else
        $("button[type='submit']").removeAttr("disabled")

$ ->
    Campaign.input_monitor()
    $("input").bind "change keyup input", ->
      Campaign.input_monitor()
