class AA
    def initialize
       test3
    end
    
    def con_coffee
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
    
    def test
        @filename = "1.txt"
        @filename2 = "2.txt"
        File.open(@filename, "r") do |f|
            @test1 = f.read
            p @test1
        end
        
        p @test1
        File.open(@filename2, "r") do |f|
            @test2 = f.read
            p @test2
        end
        
        @file = File.open("1+2.txt",'w')
        @file.print "#{@test1}\n\n#{@test2}"
        @file.close
    end
    
    def test2
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
        
        @file = File.open("controllers.coffee",'w')
        @file.print "#{@test1}\n\n#{@test2}"
        
        @file.close
        Dir::chdir("..")
    end
    
    def test3
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
