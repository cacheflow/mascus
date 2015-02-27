require "rake"

task :default do
  Rake::FileList.new("**/*rb").each do |file|
    ruby file 
end
end