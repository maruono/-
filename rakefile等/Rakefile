# "hello" を表示するだけのタスク

def tom
    puts "tom"
end

task :hello do
  puts 'hello thom'
  tom
end

task :s do
  puts system("ruby start.rb")
  puts system("monaca preview -p 8080")
end

task :c do
    puts system("ruby start.rb")
end

task :test do
   puts system("ruby test.rb") 
end

task :build do
    puts system("monaca remote build android --build-type=debug")
end

task :up do
    puts system("monaca upload")
end