require "cgi"
module CampaignsHelper
  def is_active(tea)
    params[:tea] && params[:tea].to_i == tea.id
  end

  def unescape(string)
    CGI.unescape(string)
  end

  def params_value(k1, k2, ka, kb)
    if params[k1.to_sym][k2.to_sym][ka.to_sym] and params[k1.to_sym][k2.to_sym][ka.to_sym] == "true"
      # stand the position with empty content
      if params[k1.to_sym][k2.to_sym][kb.to_sym].empty? 
        "&nbsp;"
      else
        CGI.unescape(params[k1.to_sym][k2.to_sym][kb.to_sym])
      end
    end
  end

  def params_whether_required(k)
    "required" if params[k.to_sym][:required] and params[k.to_sym][:required] == "true"
  end
end
