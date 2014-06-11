require "./config/boot.rb"

map("/users") { run UsersController }
map("/campaigns") { run CampaignsController }
map("/entity") { run EntityController }
map("/") { run HomeController }


#run Sinatra::Application
#Rack::Handler::Thin.run @app, :Port => 3000
