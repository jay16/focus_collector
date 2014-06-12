window.Campaign = 
  add_column: ->
    colnum = $(".campaign-column").length
    colnum += 1
    new_column = '<div class="form-group campaign-column new-column-' + colnum + '" data-index="' + colnum + '">'
    new_column += '  <label for="name" style="min-width:55px;">字段 ' + colnum + ' </label>'
    new_column += '  <input class="form-control" name="campaign[column' + colnum + ']" placeholder="column' + colnum + '" style="width:60%;display:inline;" type="text" value="">'
    new_column += '  <a class="btn btn-default btn-sm btn-danger" href="javascript:void(0);" onclick="Campaign.remove_column(this,' + colnum + ');">移除</a>'
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


