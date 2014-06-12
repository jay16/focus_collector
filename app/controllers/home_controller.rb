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
    @campaigns = @user.campaign
    haml :index, layout: :"../layouts/layout"
  end

  not_found { "sorry - not found!" }
end
