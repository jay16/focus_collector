#encoding: utf-8 
require "json"
require "csv"
require "fileutils"
class EntityController < ApplicationController
  #set :views, ENV["VIEW_PATH"] + "/entity"

  # get /entity
  get "/" do
    response['Access-Control-Allow-Origin'] = "*"
    return {code: 401, error: "please offer token"}.to_json if params[:token].nil?

    campaign = Campaign.all(:token => params[:token].to_s).first
    if campaign.nil?
      {code: 404, info: "not found campaign with token: #{params[:token]}"}.to_json
    else
      param = campaign.entity_params(params)
      entity = campaign.entity.first_or_create(param)
      if entity.save
        entity.reverse_trigger_action if campaign.is_reverse
        {code: 200, info: entity.to_param}.to_json
      else
        {code: 204, info: "create entity fail!"}.to_json
      end
    end
  end

  # download the entities of campaign
  # get /entity/download
  get "/download" do
    campaign = Campaign.first(token: params[:token] || "nil")

    csv_file = campaign.nil? ? "not_found_campaign.csv" : Time.now.strftime("%Y%m%d%H%M%S.csv")
    tmp_path = File.join(ENV["APP_ROOT_PATH"], "tmp")
    FileUtils.mkdir(tmp_path) if !File.exist?(tmp_path)
    csv_path = File.join(tmp_path, csv_file)

    CSV.open(csv_path, "wb:UTF-8") do |csv|
      unless campaign.nil?
        csv << campaign.virtus_params
        campaign.entity.each do |entity|
          csv << (1..campaign.colnum).map { |i| entity.instance_variable_get("@column#{i}") }
        end
      end
    end
    send_file(csv_path, filename: csv_file)
  end

  get "/reverse_url_trigger" do
    case params[:type]
    when "entity" then
      entity = Entity.first(id: params[:id])
      entity.reverse_trigger_action.to_json
    when "campaign" then
      campaign = Campaign.first(id: params[:id])
      entities = campaign.entity
      hash = {code:1, info: "0", y: 0, yf: "", n: 0, nf: ""}
      entities.each do |entity|
        h = entity.reverse_trigger_action
        if h[:code] == 1
          hash[:y] += 1
          hash[:yf] = h[:info]
        else
          hash[:n] += 1
          hash[:nf] = h[:info]
        end
      end 
      hash[:code] = 1
      hash[:info] = ["共", entities.count, "笔,成功",hash[:y], "笔-返回信息:", hash[:yf]].join
      hash[:info] += [";失败",hash[:n], "笔-返回信息:", hash[:nf]].join if hash[:n] > 0

      return hash.to_json
    else
      {code:-1, info: "the type you trigger is ambious"}.to_json
    end
  end

  get "/back" do
    params.to_json
  end

  not_found do
    "sorry, #{request.path_info} - not found!"
  end
end
