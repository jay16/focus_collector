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
    property :column1, String #=> mapping Entity
    property :column2, String
    property :column3, String
    property :column4, String
    property :column5, String
    property :column6, String
    property :column7, String
    property :column8, String
    property :column9, String
    property :column10, String
    property :column11, String
    property :column12, String
    property :column13, String
    property :column14, String
    property :column15, String
    property :column16, String
    property :column17, String
    property :column18, String
    property :column19, String
    property :column20, String
    property :column21, String
    property :column22, String
    property :column23, String
    property :column24, String
    property :column25, String
    property :column26, String
    property :column27, String
    property :column28, String
    property :column29, String
    property :column30, String
    property :created_at, DateTime, :default => DateTime.now
    property :updated_at, DateTime, :default => DateTime.now


    has n, :entity
    belongs_to :user

    def entity_params(params)
      (1..self.colnum).inject({}) do |param, i|
        colname = "column#{i}"
        colalias = self.instance_variable_get("@"+colname)
        value = params.find_all{ |k, p| k.to_s == colalias }.first[1]
        param.merge!({ "#{colname}" => value })
      end
    end

    def api_url
      query = (1..self.colnum).map do |i|
        colalias = self.instance_variable_get("@column#{i}")
        [colalias, "your_#{colalias}"].join("=")
      end.join("&")
      query = "token=campaign_token&" + query
      [api_base_url, "?", query].join
    end

    def api_base_url
      [Settings.url, "/entity"].join
    end

    def virtus_params
      (1..self.colnum).map { |i| self.instance_variable_get("@column#{i}") }
    end

    def api_virtus_params_json
      virtus_params.unshift("token").map do |colalias|
         %Q("#{colalias}": #{colalias})
      end.join(",\n\t")
    end

    def api_ajax
      js = %Q(
<script src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
<script>
function trigger_api(#{virtus_params.join(",")}) {
  $.ajax({
    type: "get",
    url: "#{api_base_url}",
    data: {
        #{api_virtus_params_json}
    },
    dataType: "json",
    success: function(data) {
      console.log(data);
    },
    error: function() {
      alert("error:get with ajax!");
    }
  });
}
</script>
      )
      CGI.escapeHTML(js)
    end

end
