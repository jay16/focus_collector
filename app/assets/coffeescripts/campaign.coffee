window.Campaign = 
  addColumn: ->
    colnum = $(".campaign-column").length
    colnum += 1
    new_column = '<div class="form-group campaign-column new-column-' + colnum + '" data-index="' + colnum + '">'
    new_column += '  <label for="name" style="min-width:55px;">字段 ' + colnum + '* </label>'
    new_column += '  <input class="form-control require column" onkeyup="Campaign.inputMonitor();" onchange="Campaign.inputMonitor();" oninput="Campaign.inputMonitor();" name="campaign[column' + colnum + ']" placeholder="column' + colnum + '" style="width:50%;display:inline;" type="text" value="">'
    new_column += '  <a class="btn btn-default btn-sm btn-danger" href="javascript:void(0);" onclick="Campaign.removeColumn(this,' + colnum + ');">移除</a>'
    new_column += '  <span class="alert alert-danger" style="display:inline;padding:5px;">不可为空;</span>'
    new_column += '</div>'
    # 逆向删除！添加新的column后，之前添加的column不可删除
    $(".campaign-column a").attr("disabled", "disabled")
    $("#campaign_form .form-group").last().after(new_column)
    $("input[name='campaign[colnum]']").val(colnum);
    Campaign.inputMonitor()

  removeColumn: (self, index) ->
    $this = $(self).parent(".campaign-column").first()
    index = parseInt($this.data("index"))
    pre_index = index - 1
    #删除自己前把前面新添的字段激活
    $(".new-column-"+pre_index+" a").removeAttr("disabled")
    #修改colnum
    $("input[name='campaign[colnum]']").val(pre_index);
    $this.remove()
    Campaign.inputMonitor()


  inputMonitor: ->
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

      if is_error == true then $warn.removeClass("hidden") else $warn.addClass("hidden")

      $warn.html(warn)
      disabled_submit = true if(is_error) 

      #默认为false，有一个错误就设置为true
      if(disabled_submit==true) 
        $("button[type='submit']").attr("disabled","disabled") 
      else
        $("button[type='submit']").removeAttr("disabled")

  checkbox: (self) ->
    state = $(self).attr("checked")
    if(state == undefined || state == "undefined")
      $(self).attr("checked", "true")
    else
      $(self).removeAttr("checked")

  codeIframeWhetherDesign: (self, form) ->
    state = $(self).attr("checked")
    if(state == undefined || state == "undefined")
      $(self).attr("checked", "true")
      $(form).removeClass("hidden")
    else
      $(self).removeAttr("checked")
      $(form).addClass("hidden")

  codeIframeFormRemoveColumn: (self, column, k) ->
    state = $(self).attr("checked")
    $labels = $("."+ column + "-" + k + "-label")
    $inputs = $("."+ column + "-" + k + "-input")
    if(state == undefined || state == "undefined")
      $(self).attr("checked", "true")
      $labels.addClass("strike")
      $inputs.addClass("strike")
      $inputs.attr("disabled", "disabled")
    else
      $(self).removeAttr("checked")
      $labels.removeClass("strike")
      $inputs.removeClass("strike")
      $inputs.removeAttr("disabled")

  postCampaignTemplate: (token, params) ->
    $.ajax(
        url: "/campaigns/template"
        type: "post"
        dataType: "json"
        data: { token: token, template: params }
        success: (data) ->
          console.log(data)
        error: (jqXHR, textStatus, errorThrown) ->
          console.log(textStatus, errorThrown)
    );
  getIframeCode: (token) ->
    $.ajax(
        url: "/campaigns/iframe_code"
        type: "get"
        dataType: "json"
        data: { token: token }
        success: (data) ->
          alert(data)
          console.log(data)
        error: (jqXHR, textStatus, errorThrown) ->
          console.log(textStatus, errorThrown)
    );

  escapeHTML: (string) ->
    entityMap =
      "&": "&amp;"
      "<": "&lt;"
      ">": "&gt;"
      "\"": "&quot;"
      "'": "&#39;"
      "/": "&#x2F;"
    String(string).replace /[&<>"'\/]/g, (s) ->
      entityMap[s]

  codeIframeFormSubmit: ->
    url   = $("input[name='code-iframe-url']").val()
    token = $("input[name='code-iframe-token']").val()
    params = new Array()
    # whether use this column
    # column[alias][isuse]
    $(".code-iframe-whether-remove").each ->
      state = $(this).attr("checked")
      column = $(this).data("column")
      klass  = $(this).data("klass")
      params.push(column + "[" + klass + "][isuse]=" + (state == undefined ? "true" : "false"))

    # column title/desc/placeholder
    # column[alias][text]
    $(".code-iframe-column").each ->
      column = $(this).data("column")
      klass  = $(this).data("klass")
      value  = Campaign.escapeHTML($(this).val())
      params.push(column + "[" + klass + "][text]=" + value)

    # column width - col-sm-3
    # column[span]
    $(".code-iframe-select").each ->
      column = $(this).data("column")
      value  = $(this).val()
      params.push(column + "[span]=" + value)

    # column whether required 
    # column[required]
    $(".code-iframe-whether-required").each ->
      state = $(this).attr("checked")
      column = $(this).data("column")
      console.log(column + " - " + state)
      params.push(column + "[required]=" + (state == "checked" ? "true" : "false"))

    url = url + "&" + params.join("&")
    Campaign.postCampaignTemplate(token, params.join("&"))
    Campaign.getIframeCode(token)
    console.log(url)
    $("#iframe").attr("src", url) 
