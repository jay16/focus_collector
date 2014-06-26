#encoding: utf-8 
require "base64"
require "json"
require "cgi"
require "net/http"
require "uri"

class CampaignsController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/campaigns"

  before do
    pass if %w(/template /entity/download).include?(request.path_info)
    authenticate!
  end

  # GET /campaigns
  get "/" do
    if params[:id] or params[:token]
      @campaign = @user.campaign.first(params[:id].nil? ? {token: params[:token]} : {id: params[:id]}) 
      haml :show, layout: :"../layouts/layout"
    else
      @campaigns = @user.campaign.all
      haml :list, layout: :"../layouts/layout"
    end
  end

  # iframe call this action
  # get /campaigns/template
  get "/template" do
    headers['X-Frame-Options'] = 'ALLOWALL'
    @campaign = Campaign.first(token: params[:token] || "")
    haml :template
  end

  # customize design iframe
  # post /campaign/template
  post "/template" do
    @campaign = Campaign.first(token: params[:token] || "")
    @campaign.update({template: params[:template]})
  end
  
  # reverse url setting
  # get /campaigns/reverse
  get "/reverse" do
    campaign = Campaign.first(token: params[:token] || "")
    if params[:url]
      url = CGI.unescape params[:url]
      ret = net_http_get(url)
      is_valid = !ret.empty?
    else
      url = campaign.reverse_url
      is_valid = campaign.reverse_url_isvalid
    end
    is_reverse = params[:is_reverse].nil? ? is_valid : (params[:is_reverse].to_i == 0 ? false : true)

    campaign.update({ reverse_url: url, is_reverse: is_reverse, reverse_url_isvalid: is_valid})
    { code: is_reverse, valid: is_valid}.to_json
  end

  #get /campaigns/new
  get "/new" do
    @campaign = @user.campaign.new
    @campaign.colnum = Settings.campaign.colnum.default # default columne number
    @form_path = "/campaigns/create"

    haml :new, layout: :"../layouts/layout"
  end

  #post /campaigns/create
  post "/create" do
    add_timestamp(params[:campaign])
    puts params[:campaign]
    @campaign = @user.campaign.create(params[:campaign])
    if @campaign.save
      @campaign.token = Base64.encode64([Time.now.to_i, @user.id, @campaign.id].join("@")).strip
      @campaign.save
      redirect "/campaigns?id=#{@campaign.id}" 
    else
      haml :new, layout: :"../layouts/layout"
    end

  end

  get "/:id/entities" do
    @campaign = @user.campaign.first(id: params[:id])
    haml :entity, layout: :"../layouts/layout"
  end

  #get /campaigns/1/edit
  get "/:id/edit" do
    @campaign = @user.campaign.first(id: params[:id])
    @form_path = "/campaigns/#{params[:id]}/update"
    
    haml :edit, layout: :"../layouts/layout"
  end

  #post /campaigns/1/update
  post "/:id/update" do
    @campaign = @user.campaign.first(id: params[:id])
    @campaign.update(params[:campaign])

    redirect "/campaigns?id=#{params[:id]}"
  end

  #delete /campaigns/1
  delete "/:id" do
    @campaign = @user.campaign.first(id: params[:id])
    @campaign.destroy
  end

  def net_http_get(url, params = {})
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(params) if !params.empty?
    ret = ""
    begin
      res = Net::HTTP.get(uri) #, {"accept-encoding" => "UTF-8"})
      ret = res.is_a?(Net::HTTPSuccess) ? res.body : res
    rescue => e
      puts uri.to_s
      puts e.message
    end
    return ret
  end

end
