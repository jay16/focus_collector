#encoding: utf-8
require File.expand_path '../../spec_helper.rb', __FILE__

describe "GenerateStaticFiles" do
  def response; last_response; end
  def request;  last_request;  end

  def generate_static_template(response, file)
    static_home = File.join(ENV["APP_ROOT_PATH"], "app/views/home", file)
    File.open(static_home, "w+") do |file|
      file.puts response.body.strip
    end
  end

  # test database should consistent with development database
  before:all do
    `cd #{File.join(ENV['APP_ROOT_PATH'],'db')} && cp *_development.db *_test.db` 
  end

  it "generate /home files" do
    get "/admin/template?template=home" 
    generate_static_template(response, "home.erb")

    expect(response.body.size).to be > 0
  end

  it "generate /cart browser files" do
    get "/admin/template?template=cart" 

    generate_static_template(response, "cart.erb")
    expect(response.body.size).to be > 0
  end

  it "generate /cart mobile browser files" do
    get "/admin/template?template=mobile_cart"
    generate_static_template(response, "mobile_cart.erb")

    expect(response.body.size).to be > 0
  end
end

