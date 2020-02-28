require 'byebug'

class Folder

  attr_accessor :name, :parent_location, :created_at, :created_by

  def initialize (name, parent_location, created_by)

    @name = name
    @parent_location = parent_location
    @created_at = Time.now
    @created_by = created_by
  end

  def metadata

    metadata = {:created_at => self.created_at.to_s, :created_by => self.created_by.to_s}

    return metadata
  end

  def type

    return 'folder'
  end
end # End of class Folder

def whereami(folder, folders) # Method to build path of the folder. 'folder' is the actual folder and 'folders' is an array of all folders

  flag = folder
  track = []

  loop do

    unless flag.name=='/'

      track.unshift(flag.name) 

      unless flag.parent_location.split('/').count<=2

        flag = folders.select{|i| i.parent_location+'/'+i.name==flag.parent_location}.first

      else

        flag = folders.select{|i| i.parent_location+i.name==flag.parent_location}.first

      end

    else

      flag = folders.select{|i| i.parent_location+i.name==flag.parent_location}.first

    end

    break if flag.nil?

  end

  return  (track.empty? ? '/' : '/'+track.join('/').to_s) #Return full path 
end

def search_parent(folder , folders) # Method to searh and return the parent directory of a foldaer. 'folder' is the actual folder and 'folders' is an array of all folders

  parent_location = folder.parent_location

  unless parent_location == ''

    flag = ''

    location = parent_location[0,parent_location.index(/((\/(([A-z0-9]*))){1}\z)/)] # serching with Regex. Search last '/'

    unless parent_location.split('/').count<=2

      flag = folders.select{|i| i.parent_location==location}.first

    else

      flag = folders.select{|i| i.parent_location+i.name==parent_location}.first

    end

    return flag # Return the parent object of 'folder'

  else

    return folder

  end
end


class Filee

  attr_accessor :name, :parent_location, :content , :created_at, :created_by
 
  def initialize (name, parent_location, content, created_by)
    @name=name
    @parent_location = parent_location
    @content=(content.nil? ? '' : content)
    @created_at = Time.now
    @created_by = created_by
  end

  def show
    return self.content.to_s
  end

  def metadata
    metadata = {:created_at => self.created_at.to_s, :created_by => self.created_by.to_s}
    return metadata
  end

  def type
    return 'File'
  end
end # End of class Filee. Name 'Filee' is used to avoid overriding 'File' class

  folders = []
  files = []
  user = "default_user"

  root_path = Folder.new "/","",user # Defines root directory
  
  folders.push(root_path)

  act_location = root_path
  

loop do 
  # debugger

  command=nil
  input=nil

  print '# '+(act_location==root_path ? act_location.name : whereami(act_location,folders)+'/' )+' > '

  input = gets.chomp
  command = input.split /\s/ #split input by whitespace

  case command[0]

    when 'create_folder'
      #validates if object name exists in the same directory
      unless command[1].to_s.nil? || !folders.select{|i| i.name==command[1].to_s && i.parent_location==whereami(act_location,folders)}.empty?
        f = Folder.new command[1].to_s,whereami(act_location,folders),user 
        folders.push(f)
        puts 'Folder '+command[1].to_s+' created!'
      else
        puts 'The folder name exists or is empty'
      end

    when 'create_file'
      #validates if object name exists in the same directory
      unless command[1].to_s.nil? || !files.select{|i| i.name==command[1] && i.parent_location==act_location.name}.empty?
        fl=Filee.new command[1].to_s,act_location.name,input.split(/"/)[1],user
        files.push(fl)
        puts 'File '+command[1].to_s+' created!'
      else
        puts 'The file name exists or is empty'
      end

    when 'show'
      unless command[1].nil? || files.select{|i| i.name==command[1] && i.parent_location==act_location.name}.empty?
        content = (files.select{|i| i.name==command[1] && i.parent_location==act_location.name}).first
        puts content.name+':'
        puts 'Content: '+content.show
      else
        puts 'File doesn\'t exists'
      end

    when 'metadata'
      unless command[1].nil? || files.select{|i| i.name==command[1] && i.parent_location==act_location.name}.empty?
        metadata = (files.select{|i| i.name==command[1] && i.parent_location==act_location.name}).first
        puts metadata.name+':'
        puts 'created_at: '+metadata.metadata[:created_at] + ', created_by: '+metadata.metadata[:created_by]
            else
        puts 'File doesn\'t exists'
      end

    when 'ls'

      act_path_fd = folders.select{|i| i.parent_location==whereami(act_location,folders)} unless folders.select{|i| i.parent_location==whereami(act_location,folders)}.empty?
      act_path_fl = files.select{|i| i.parent_location==act_location.name} unless files.select{|i| i.parent_location==act_location.name}.empty?

      unless act_path_fd.nil? && act_path_fl.nil?
        act_path_fd.each{|i| puts i.name + ' | ' + i.type } unless act_path_fd.nil? 
        act_path_fl.each{|i| puts i.name + ' | ' + i.type } unless act_path_fl.nil?
      else
        puts 'Empty Folder'
      end

    when 'whereami'

      puts 'Path: '+ whereami(act_location, folders)

    when 'cd'
      
      unless command[1].nil? 

        unless command[1].to_s == '..'

          unless folders.select{|i| i.name==command[1].to_s && i.parent_location==whereami(act_location,folders)}.empty?

            child_folders = folders.select{|i| i.parent_location==whereami(act_location,folders)} 
            
            act_location=child_folders.select{|i| i.name==command[1]}.first

          else
            puts 'Folder doesn\'t exists'
          end

        else
          act_location=search_parent(act_location,folders)

        end

      else 
         puts 'Folder not specified'
      end

    when 'destroy'

      unless command[1].nil?

        act_path_fd = folders.select{|i| i.parent_location==whereami(act_location,folders) && i.name==command[1]}
        act_path_fl = files.select{|i| i.parent_location==whereami(act_location,folders) && i.name==command[1]}

        # unless act_path_fl.empty? && act_path_fd.empty?

        #   files = files - act_path_fl #unless act_path_fl.empty?

        #   folders = folders - act_path_fd #unless act_path_fd.empty?

        #   puts 'File: '+ command[1].to_s + ' deleted!' unless act_path_fl.empty?
        #   puts 'Folder: '+ command[1].to_s + ' deleted!' unless act_path_fd.empty?

        # else

        #   puts 'File or Folder doesn\'t exists'

        # end

        if act_path_fl.any? && act_path_fd.any?
          loop do
            puts 'A file and a folder have the same name (' + command[1] + '). Which one want you to destroy?'
            print 'File <1> | Folder <2> | Both <3> | None <4> :'
            opt = gets.chomp

            case opt.to_s
              when '1'
                files = files - act_path_fl #unless act_path_fl.empty?
                puts 'File: '+ command[1].to_s + ' deleted!' unless act_path_fl.empty?
                break
              when '2'
                folders = folders - act_path_fd #unless act_path_fd.empty?
                puts 'Folder: '+ command[1].to_s + ' deleted!' unless act_path_fd.empty?
                break
              when '3'
                files = files - act_path_fl #unless act_path_fl.empty?
                folders = folders - act_path_fd #unless act_path_fd.empty?

                puts 'File: '+ command[1].to_s + ' deleted!' unless act_path_fl.empty?
                puts 'Folder: '+ command[1].to_s + ' deleted!' unless act_path_fd.empty?

                break

              when '4' 
                puts 'None have been deleted!'
                break
              else
                puts 'Invalid option'
            end
          end

        else

          puts 'File or Folder doesn\'t exists'

        end

      else
        puts 'Name of object to destroy was not specified'
      end

    when 'exit'

      break

    when 'debugger'

      debugger

    else
      puts 'Invalid command'
  end

end