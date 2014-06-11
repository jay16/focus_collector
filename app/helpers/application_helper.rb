module ApplicationHelper

  # flash/notice message will show on layout
  # when redirect
  def notice_message
     #close = link_to("x", "#", { :class => "close", "data-dismiss" => "alert" })
     tag(:div, flash[:notice], { :class => "alert alert-success" }) if flash[:notice]
  end

  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                        'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
  # check remote client whether is mobile
  # define different layout
  def mobile?
    agent_str = request.env["HTTP_USER_AGENT"].to_s.downcase
    return false if agent_str =~ /ipad/
    agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  end

  # generate keywords from obj
  # for js search function
  def keywords(obj)
    dirty_words = %w(ip browser created_at updated_at _key _collection _repository _persistence_state)
    obj.instance_variables.reject { |v| dirty_words.include?(v.to_s.gsub("@","")) }
    .map { |var| obj.instance_variable_get(var).to_s }.join(" ")
  end
end
