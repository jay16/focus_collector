require "date"
require "settings.rb"
configure do
  db_name =[ENV["APP_NAME"], ENV["RACK_ENV"]].join("_")
  #DataMapper::setup(:default, "sqlite3://#{ENV['APP_ROOT_PATH']}/db/#{db_name}.db")
  mysql_connection = "#{Settings.database.mysql.user}:#{Settings.database.mysql.password}@#{Settings.database.mysql.host}"
  DataMapper::setup(:default, "mysql://#{mysql_connection}/#{db_name}")

  # 加载所有models
  Dir.glob("#{ENV['APP_ROOT_PATH']}/app/models/*.rb").each { |file| require file if file != "settings.rb" }

  # 自动迁移数据库
  #DataMapper.finalize.auto_migrate!
  DataMapper.finalize.auto_upgrade!

  #启动后保证db文件有被读写权限
  system("chmod 777 #{ENV['APP_ROOT_PATH']}/db/*")
end

