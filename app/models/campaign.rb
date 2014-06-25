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
    property :template, Text, :default => ""
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

    def virtus_params
      (1..self.colnum).map { |i| self.instance_variable_get("@column#{i}") }
    end
    
    def template_url 
      [Settings.url, "/campaigns/template", "?", "token=#{self.token}"].join
    end


    def api_base_url
      [Settings.url, "/entity"].join
    end

    def api_url
      query = (1..self.colnum).map do |i|
        colalias = self.instance_variable_get("@column#{i}")
        [colalias, "your_#{colalias}"].join("=")
      end.join("&")
      [api_base_url, "?", "token=#{self.token}&" + query].join
    end

    # find value from params in iframe code
    def iframe_params_find_value(vp, k, h)
      param = [vp, "[", k, "][", h, "]="].join
      finds = (self.template || "").split("&").find_all { |v| v.include?(param) }
      if finds.empty?
        h == "isuse" ?  "true" : "#{vp} #{k}"
      else
        finds.first.sub(param, "")
      end
    end
    # find value from params in iframe code
    # only for column[span] - bootstrap col span
    def iframe_params_find_span(vp)
      param = [vp, "[span]="].join
      finds = (self.template || "").split("&").find_all { |v| v.include?(param) }
      span = (12/(virtus_params.count + 1)).to_i
      finds.empty? ? span.to_s : finds.first.sub(param, "")
    end

    # whether column is required
    def iframe_params_find_required(vp)
      param = [vp, "[required]="].join
      finds = (self.template || "").split("&").find_all { |v| v.include?(param) }
      finds.empty? ? "true" : finds.first.sub(param, "")
    end

    # column[title]{text => text, isuse => true}
    #def iframe_url
    #  base = [Settings.url, "/campaigns/template", "?", "token=#{self.token}&output=embed"].join
    #  kit = %w(title desc placeholder)
    #  hh = %w(text isuse)
    #  params = virtus_params.map { |v| 
    #    kit.map { |k| 
    #      hh.map {  |h| [v, "[", k, "][", h, "]="].join + iframe_params_find_value(v, k, h) } 
    #    }
    #  }.flatten
    #  params += virtus_params.map { |v| [v, "[span]="].join + iframe_params_find_span(v) }
    #  params += virtus_params.map { |v| [v, "[required]="].join + iframe_params_find_required(v) }

    #  kit = %w(title desc text)
    #  params += kit.map { |k|
    #    v = "submit"
    #    hh.map { |h| [v, "[", k, "][", h, "]="].join + iframe_params_find_value(v, k, h) }
    #  }.flatten
    #  base + "&"+ params.flatten.join("&") + "&submit[span]=" + iframe_params_find_span("submit")
    #end

    def iframe_code
      CGI.escapeHTML %Q(<iframe id="iframe" src="#{template_url}" allowTransparency=true style="background-color:transparent;width:100%;border:none;min-height:10px;padding:0px;margin:0px;"></iframe>)
    end

    def api_virtus_params_json
      %Q(token: "#{self.token}",\n#{" "*12}) + virtus_params.map { |vp| %Q(#{vp}: encodeURI(#{vp})) }.join(",\n" + " "*12)
    end

    def api_console_log
      virtus_params.map { |vp| %(console.log("#{vp}:" + data.info.#{vp})) }.join(";\n\t\t")
    end

    def api_ajax_code
      codes = CGI.escapeHTML %Q(
        <script src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
        <script>
        function triggerApi(#{virtus_params.join(",")}) {
            $.ajax({
                url: "#{api_base_url}",
                type: "get",
                async: false,
                dataType: "json",
                crossDomain: true,
                data: {
                    #{api_virtus_params_json}
                }, success: function(data) {
                   if(parseInt(data.code)==200) {
                        //定制功能请修改下面代码
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
      # delete the white space in front of each row code
      codes.split("\n").map { |line| line.sub(" "*8, "") }.join("\n")
    end

end
