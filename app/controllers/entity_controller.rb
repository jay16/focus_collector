#encoding: utf-8 
require "json"
class EntityController < ApplicationController
  #set :views, ENV["VIEW_PATH"] + "/entity"

  get "/" do
    return { code: 401, error: "please offer token" }.to_json if params[:token].nil?

    campaign = Campaign.all(:token => params[:token].to_s).first
    if campaign.nil?
      { code: 404, info: "error: not found campaign with token" }.to_json
    else
      param = campaign.entity_params(params)
      entity = campaign.entity.first_or_create(param)
      if entity.save
        { code: 200 }.merge(entity.to_param).to_json
      else
        { code: 204, info: "create entity fail!" }.to_json
      end
    end
  end

  not_found do
    "sorry, #{request.path_info} - not found!"
  end
end
