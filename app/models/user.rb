#encoding: utf-8
class User
    include DataMapper::Resource

    property :id, Serial, :key => true
    property :name, String
    property :email, String, :required => true, :unique => true
     # :format => /\w+(?:[\.\-]\w+)*@\w+(?:[\.\-]\w+)*/, 
     # :messages => { :present => "邮箱为必填项", :is_unique => "此邮箱已被注册", :format => "邮箱格式不正确"}
    property :password, String
    property :state, String
    property :ip, String # remote ip
    property :browser, String 
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :campaign
end
