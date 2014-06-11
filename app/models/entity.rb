class Entity
    include DataMapper::Resource

    property :id, Serial 
    property :campaign_id, Integer
    property :column1, String
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
    property :created_at, DateTime
    property :updated_at, DateTime

    belongs_to :campaign

    def to_param
      campaign = self.campaign
      (1..campaign.colnum).inject({}) do |param, i|
        key = campaign.instance_variable_get("@column#{i}")
        value = self.instance_variable_get("@column#{i}")
        param.merge!({ key.to_sym => value })
      end.merge({ 
        created_at: self.instance_variable_get("@created_at").strftime("%Y-%m-%d %H:%M:%S"),
        updated_at: self.instance_variable_get("@updated_at").strftime("%Y-%m-%d %H:%M:%S")
      })

    end
end
