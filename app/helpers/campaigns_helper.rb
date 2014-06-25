require "cgi"
module CampaignsHelper

  def is_active(tea)
    params[:tea] && params[:tea].to_i == tea.id
  end

  def unescape(string)
    CGI.unescape(string)
  end

  def template_value(str, vp, k1, k2=nil)
    if !k2.nil?
      key = [vp, "[", k1, "][", k2, "]="].join
    else
      key = [vp, "[", k1, "]="].join
    end
    finds = str.split(/&/).find_all { |d| d.include?(key) }
    finds.first.sub(key, "") if !finds.empty?
  end

  def template_value_whether_isuse(str, vp, k1, ka, kb)
    if template_value(str, vp, k1, ka) == "true"
      value = template_value(str, vp, k1, kb)
      value.empty? ? "&nbsp;" : unescape(value)
    end
  end

  def params_whether_required(str, k)
    "required" if template_value(str, k, "required") == "true" 
  end
end
