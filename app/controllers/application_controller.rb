#encoding: utf-8
class ApplicationController < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Flash
  # register Sinatra::Auth

  helpers ApplicationHelper
  helpers CampaignsHelper
  helpers HomeHelper
  helpers EntityHelper
  helpers Sinatra::FormHelpers
  
  enable :sessions, :logging, :dump_errors, :raise_errors, :static, :method_override

  # css/js/view配置文档
  use SassHandler
  use CoffeeHandler
  use AssetHandler

  #load css/js/font file
  get "/js/:file" do
    disposition_file("javascripts")
  end
  get "/css/:file" do
    disposition_file("stylesheets")
  end

  def disposition_file(file_type)
    file = File.join(ENV["APP_ROOT_PATH"],"app/assets/#{file_type}/#{params[:file]}")
    send_file(file, :disposition => :inline) if File.exist?(file)
  end

  #global shared function
  ##############################################
  #authen user
  def authenticate! 
    if request.cookies["login_state"].to_s.strip.empty?
      # 记录登陆前的path，登陆成功后返回至此path
      response.set_cookie "before_login_path", {:value=> request.env["REQUEST_PATH"], :path => "/", :max_age => "2592000"}

      flash[:notice] = "继续操作前请登录."
      redirect "/users/login"
    else
      @user = User.first(:id => request.cookies["login_state"].to_i)
    end
  end

  def remote_ip
    request.env["REMOTE_ADDR"] || "n-i-l"
  end

  def remote_browser
    request.env["HTTP_USER_AGENT"] || "n-i-l"
  end

  def add_timestamp(params)
    params.merge!({ created_at: DateTime.now, updated_at: DateTime.now })
  end
  def add_updated_at(params)
    params.merge!({ updated_at: DateTime.now })
  end


end
