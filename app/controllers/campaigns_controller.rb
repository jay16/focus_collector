#encoding: utf-8 
require "base64"
class CampaignsController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/campaigns"

  before do
    pass if %w(/template).include?(request.path_info)
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
  get "/template" do
    headers['X-Frame-Options'] = 'ALLOWALL'
    @campaign = Campaign.first(:token => params[:token] || "")
    haml :template
  end

  # customize design iframe
  post "/template" do
    @campaign = Campaign.first(:token => params[:token] || "")
    @campaign.update({template: params[:template]})
  end
  
  # get iframe code
  get "/iframe_code" do
    @campaign = Campaign.first(:token => params[:token] || "")
    haml :iframe_code
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
    @campaign = @user.campaign.first(:id => params[:id])
    @form_path = "/campaigns/#{params[:id]}/update"
    
    haml :edit, layout: :"../layouts/layout"
  end

  #post /campaigns/1/update
  post "/:id/update" do
    #add_updated_at(params[:campaign])
    puts params[:campaign]

    @campaign = @user.campaign.first(:id => params[:id])
    @campaign.update(params[:campaign])

    redirect "/campaigns?id=#{params[:id]}"
  end

  #delete /campaigns/1
  delete "/:id" do
    @campaign = @user.campaign.first(:id => params[:id])
    @campaign.destroy
  end
end
