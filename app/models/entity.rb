#encoding: utf-8
require "cgi"
require "net/http"
require "uri"
class Entity
    include DataMapper::Resource

    property :id, Serial 
    property :campaign_id, Integer
    (1..Settings.campaign.colnum.maximum || 32).each { |i| property "column#{i}".to_sym, String } #=> mapping Entity 
    property :created_at, DateTime
    property :updated_at, DateTime

    belongs_to :campaign

    def to_param(containTimestamp = true)
      campaign = self.campaign
      params = (1..campaign.colnum).inject({}) do |param, i|
        key = campaign.instance_variable_get("@column#{i}")
        value = self.instance_variable_get("@column#{i}")
        # value = (value.nil? || value.strip.empty?) ? "nil" : value
        param.merge!({ key.to_sym => value })
      end
      params.merge({ 
        created_at: self.instance_variable_get("@created_at").strftime("%Y-%m-%d %H:%M:%S"),
        updated_at: self.instance_variable_get("@updated_at").strftime("%Y-%m-%d %H:%M:%S")
      }) if containTimestamp
      puts params.to_s
      return params
    end

    # concate campaign's reverse_url and entity.params 
    # as reverse uri
    def reverse_trigger_uri
      uri = URI.parse(self.campaign.reverse_url)
      uri.query = URI.encode_www_form(self.to_param)
      return uri
    end

    # trigger reverse uri
    def reverse_trigger_action
      net_http_get(reverse_trigger_uri)
    end

    def net_http_get(uri)
      begin
        res = Net::HTTP.get(uri) #, {"accept-encoding" => "UTF-8"})
        ret = res.is_a?(Net::HTTPSuccess) ? res.body : res
        ret = "返回信息过大 - " + CGI.escapeHTML(ret[0..100]) + "..." if ret.length > 1000
        hash = {code: 1, info: ret}
      rescue => e
        hash = {code: 0, info: e.message}
      end
      return hash
    end
end
