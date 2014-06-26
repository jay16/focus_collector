class Entity
    include DataMapper::Resource

    property :id, Serial 
    property :campaign_id, Integer
    (1..Settings.campaign.colnum.maximum).each { |i| property "column#{i}".to_sym, String } #=> mapping Entity 
    property :created_at, DateTime
    property :updated_at, DateTime

    belongs_to :campaign

    def to_param
      campaign = self.campaign
      (1..campaign.colnum).inject({}) do |param, i|
        key = campaign.instance_variable_get("@column#{i}")
        value = self.instance_variable_get("@column#{i}")
        # value = (value.nil? || value.strip.empty?) ? "nil" : value
        param.merge!({ key.to_sym => value })
      end.merge({ 
        created_at: self.instance_variable_get("@created_at").strftime("%Y-%m-%d %H:%M:%S"),
        updated_at: self.instance_variable_get("@updated_at").strftime("%Y-%m-%d %H:%M:%S")
      })

    end
end
