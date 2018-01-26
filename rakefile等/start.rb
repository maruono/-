require 'slim'
require "coffee-script"

module Slim
    Engine.set_options disable_escape: true, use_html_safe: false
    
    class ERBConverter < Engine
        replace :StaticMerger, Temple::Filters::CodeMerger
        replace :Generator, Temple::Generators::ERB
    end
    
    class BB
        # filename is ".slim"
        def initialize(filename)
            @filename = filename
            test
        end
        
        def test
            File.open(@filename, "r") do |f|
                @test1 = f.read
                #p @test1
            end
            #p @test1
            @slim = ERBConverter.new.call(@test1)
            @file = File.open("#{@filename.gsub(/.slim/, "")}.html",'w')
            @file.print @slim
            @file.close
        end
    end
    
    class CC
        # filename is ".slim"
        def initialize(filename)
            @filename = filename
            test
        end
        
        def test
            File.open(@filename, "r") do |f|
                @test1 = f.read
                #p @test1
            end
            #p @test1
            Dir::chdir("..")
            Dir::chdir("./www")
            Dir::chdir("./templates")
            @slim = ERBConverter.new.call(@test1)
            
            @file = File.open("#{@filename.gsub(/.slim/, "")}.html",'w')
            @file.print @slim
            @file.close
            Dir::chdir("..")
            Dir::chdir("..")
            Dir::chdir("./slim")
        end
    end
end

class AA
    def initialize
        controllers
        #generate
        generate_slim
        generate_coffee
        start

    end
    
    def start
        Dir::chdir("./www")
        Slim::BB.new("index.slim")
        @slim = Slim::Template.new("index.slim").render(self)
        @file = File.open("index.html",'w')
        @file.print @slim
        @file.close
        Dir::chdir("..")
        #puts system("monaca preview -p 8080")
    end
    
    def generate
        Dir::chdir("./www")
        Dir::chdir("./templates")
        @str = Dir.glob(["*.slim"])
        @str.each do |name|
            #p ("#{name}")
            Slim::BB.new(name)
        end
        Dir::chdir("..")
        Dir::chdir("..")
    end
    
    def generate_slim
        Dir::chdir("./slim")
        @str = Dir.glob(["*.slim"])
        @str.each do |name|
            #p ("#{name}")
            Slim::CC.new(name)
        end
        Dir::chdir("..")
    end
    
    def generate_coffee
        Dir::chdir("./www")
        Dir::chdir("./js")
        #puts system("coffee -c test.coffee")
        
        
        @str2 = Dir.glob(["*.coffee"])
        @str2.each do |name|
            p ("#{name}")
            puts system("coffee -c -b #{name}")
        end
        Dir::chdir("..")
        Dir::chdir("..")
    end
    
    def controllers
        Dir::chdir("./coffee")
        @filename = "_lib.coffee"
        @filename2 = "_controllers.coffee"
        File.open(@filename, "r") do |f|
            @test1 = f.read
            p @test1
        end
        
        File.open(@filename2, "r") do |f|
            @test2 = f.read
            p @test2
        end
        
        Dir::chdir("..")
        Dir::chdir("./www")
        Dir::chdir("./js")
        
        @file = File.open("controllers.coffee",'w')
        @file.print "#{@test1}\n\n#{@test2}"
        @file.close
        
        Dir::chdir("..")
        Dir::chdir("..")
    end
end

AA.new


