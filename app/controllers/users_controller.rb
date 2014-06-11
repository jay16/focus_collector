#encoding: utf-8 
class UsersController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/users"

  #无权限则登陆
  #当前controller中默认url path前缀为/admin
  before do 
    pass if %w(/new /create /login /chklogin).include?(request.path_info)
    authenticate!
  end

  # GET /users/new
  get "/new" do
    haml :new, layout: :"../layouts/layout"
  end

  # post /users/create
  post "/create" do
    user = User.create(params[:user])
    if user.save
      user.name = user.email.split("@").first
      user.save
      flash[:notice] = "注册成功，请登陆."
      redirect "/users/login"
    else
      flash[:notice] = user.errors.join("<br>")
      redirect "/users/new"
    end
  end

  # GET /users/login
  get "/login" do
    unless request.cookies["login_state"].to_s.strip.empty?
      redirect "/"
    else
      haml :login, layout: :"../layouts/layout"
    end
  end

  # chk name and password
  # post /users/chklogin
  post "/chklogin" do
    user = User.first(:email => params[:user][:email])# :password => params[:password])
    if !user.nil?
      # 必须指定path，否则cookie只在此path下有效
      # authencate! 在application_controller下，即"/"
      response.set_cookie "login_state", {:value=> user.id, :path => "/", :max_age => "2592000"}

      redirect request.cookies["before_login_path"] || "/"
    else
      response.set_cookie "login_state", {:value=> "", :path => "/", :max_age => "2592000"}

      flash[:notice] = "登陆失败，请重新输入." + params[:user].to_s + "-"
      redirect "users/login"
    end
  end

  get "/logout" do
    response.set_cookie "login_state", {:value=> "", :path => "/", :max_age => "2592000"}
    redirect "/"
  end

end
