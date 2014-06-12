#encoding: utf-8
require "cgi"
class Campaign
    include DataMapper::Resource

    property :id, Serial 
    property :user_id, Integer, :required => true
    property :name, String, :required => true 
    property :desc, String
    property :token, String
    property :colnum, Integer, :default => 3
    (1..Settings.campaign.colnum.maximum).each { |i| property "column#{i}".to_sym, String } #=> mapping Entity 
    property :created_at, DateTime, :default => DateTime.now
    property :updated_at, DateTime, :default => DateTime.now

    has n, :entity
    belongs_to :user

    def entity_params(params)
      (1..self.colnum).inject({}) do |param, i|
        colname = "column#{i}"
        colalias = self.instance_variable_get("@"+colname)
        value = params.find_all{ |k, p| k.to_s == colalias }.first[1]
        param.merge!({ "#{colname}" => CGI.unescape(value) })
      end
    end

    def api_url
      query = (1..self.colnum).map do |i|
        colalias = self.instance_variable_get("@column#{i}")
        [colalias, "your_#{colalias}"].join("=")
      end.join("&")
      query = "token=#{self.token}&" + query
      [api_base_url, "?", query].join
    end

    def api_base_url
      [Settings.url, "/entity"].join
    end

    def virtus_params
      (1..self.colnum).map { |i| self.instance_variable_get("@column#{i}") }
    end

    def api_virtus_params_json
      %Q(token: "#{self.token}",\n\t\t) + virtus_params.map { |vp| %Q(#{vp}: encodeURI(#{vp})) }.join(",\n\t\t")
    end

    def api_console_log
      virtus_params.map { |vp| %(console.log("#{vp}:" + data.info.#{vp})) }.join(";\n\t\t")
    end

    def api_ajax
      js = %Q(
<script src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
<script>
function triggerApi(#{virtus_params.join(",")}) {
    $.ajax({
        crossDomain: true,
        async: false,
        type: "get",
        url: "#{api_base_url}",
        dataType: "json",
        data: {
            #{api_virtus_params_json}
        }, success: function(data) {
           if(parseInt(data.code)==200) {
                #{api_console_log}
            } else {
                console.log("api error:" + data.code + " - " + data.info);
            }
        }, error: function(jqXHR, textStatus, errorThrown) {
            console.log(textStatus, errorThrown);
        }
    });
}
</script>
      )
      CGI.escapeHTML(js)
    end

end
