desc "tasks around CoffeeScript"
namespace :cs2js do
  desc "CoffeeScript Complie file to JS file"
  task :complie => :environment do
     javascript_path = File.join(ENV["APP_ROOT_PATH"],"app/assets/javascripts")
     coffeescript_path = File.join(ENV["APP_ROOT_PATH"],"app/assets/coffeescripts")
     coffeescripts = Dir.entries(coffeescript_path).select { |cs| cs if cs =~ /.*?\.coffee$/ }
     coffeescripts.each do |coffeescript_file|
       bint = Time.now.to_f
       begin
         file = File.open(File.join(javascript_path, File.basename(coffeescript_file, ".coffee") + ".js"), "w+")
         file.puts CoffeeScript.compile(File.read(File.join(coffeescript_path,coffeescript_file)))
         file.close
       rescue => e
         puts e.backtrace
       end
       eint = Time.now.to_f
       printf("%-20s - CoffeScript Complie over.[%sms]\n", coffeescript_file, ((eint - bint)*1000).to_i)
     end if !coffeescripts.empty?
  end
end
