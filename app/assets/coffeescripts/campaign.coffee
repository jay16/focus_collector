window.Campaign = 
  add_column: ->
    colnum = $(".campaign-column").length
    colnum += 1
    new_column = '<div class="form-group campaign-column new-column" data-num=' + colnum + '>'
    new_column += '  <label for="name" style="min-width:55px;">字段 ' + colnum + ' </label>'
    new_column += '  <input class="form-control" name="campaign[column' + colnum + ']" placeholder="column' + colnum + '" style="width:60%;display:inline;" type="text" value="">'
    new_column += '  <a class="btn btn-default btn-sm btn-danger" href="#" onclick="Campaign.remove_column(' + colnum + ');">移除</a>'
    new_column += '</div>'
    # 逆向删除！添加新的column后，之前添加的column不可删除
    $(".new-column a").attr("disabled", "disabled")
    $("#campaign_form .form-group").last().append(new_column)

