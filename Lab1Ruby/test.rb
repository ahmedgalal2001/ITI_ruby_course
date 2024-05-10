class Inventory
    @@id_inventory=1
    attr_accessor :books
    def initialize()
        @id = @@id_inventory
        @@id_inventory +=1
        @books = []
    end
    def add_book(title, authen)
        book = Book.new title , authen
        handel = HandelFiles.new "ahmed" , 'a'
        handel.write_data(book.format)
    end
    def list_books()
        handel = HandelFiles.new "ahmed" , 'r'
        puts "ISBN\t\tTitle\t\tAuthor"
        puts "--------------------------------------------"
        handel.read_data.each do |book|
            data = book.split(";")
            puts "#{data[0]}\t\t#{data[1]}\t\t#{data[2]}\n"
        end
    end
    def search_book(id)
        handel = HandelFiles.new "ahmed" , 'r'
        index = 0
        flag = 0
        for book in handel.read_data
            index +=1
            if(book.include? "#{id};")
                flag=1
                break
            end
        end
        return [index,flag]
    end
    def find_book(id)
        index,flag = search_book(id)
        if(flag==1)
            handel = HandelFiles.new "ahmed" , 'r'
            puts "ISBN\t\tTitle\t\tAuthor"
            puts "--------------------------------------------"
            data =  handel.read_data[index-1].split(";")
            puts "#{data[0]}\t\t#{data[1]}\t\t#{data[2]}\n"
        else 
            # to show error message by color red
            print "\e[31m not found\e[0m"
        end
    end

    def remove_book(id)
        index,flag = search_book(id)
        if(flag==1)
            data = handel.read_data
            data.delete_at(index - 1)
            write = HandelFiles.new "ahmed" , "w+"
            data.each {|book| write.file.syswrite(book)}
            print "removed"
        else 
            # to show error message by color red
            print "\e[31m not found\e[0m"
        end
    end
end

class Book
    @@id_book = 1
    attr_accessor :title, :authen , :ISBN
    def initialize(title,authen)
        init_isbn()
        @title = title
        @authen = authen
        @ISBN = @@id_book
        @@id_book +=1
    end
    # def init_isbn to prvent repeated ISBN
    def init_isbn()
        handel = HandelFiles.new "ahmed" , 'r'
        data = handel.read_data
        if data.length > 0
            last_isbn = data.last.split(";")[0].to_i
            @@id_book = last_isbn + 1
        end
    end
    def format()
        return "#{@ISBN};#{@title};#{@authen}"
    end
end


class HandelFiles
    attr_accessor :file
    attr_accessor :nameFile
    attr_accessor :mode
    def initialize(nameFile,mode)
        @nameFile = "#{nameFile}.txt"
        @mode = mode
        @file = File.new "#{@nameFile}" , "#{@mode}"
    end
    def write_data(data)
        @file.syswrite("#{data}\n")
    end
    def read_data()
        content = File.readlines("#{@nameFile}")
        return content
    end
end



def interface()
    flag = 0
    while flag==0
        print "\n1.List Books\n"
        print "2.Add New Book\n"
        print "3.Remove Book By ISBN\n"
        print "4.search Book By ISBN\n"
        print "5.Exit\n"
        print "Enter your choice : ";input = gets().to_i
        invent = Inventory.new
        case input
        when 1
            invent.list_books()
        when 2
            print "Enter title: "
            title = gets().chomp
            print "Enter author: "
            authen = gets().chomp
            invent.add_book(title,authen)
        when 3
            print "Enter your Id: "
            id = gets().chomp
            invent.remove_book(id)
        when 4
            print "Enter your Id: "
            id = gets().chomp
            invent.find_book(id)
        when 5
            flag = 1
        else
            flag = 1
        end
    end
end


interface