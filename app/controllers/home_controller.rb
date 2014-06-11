#encoding: utf-8 
require "net/http"
require "uri"
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"

  before do
    authenticate!
  end

  # root
  get "/" do
    @campaigns = Campaign.all(:user_id => @user.id)
    haml :index, layout: :"../layouts/layout"
  end

  not_found do
    "sorry"
  end
end
