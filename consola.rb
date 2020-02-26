require 'byebug'

class Folder

  attr_accessor :name, :parent_location, :created_at, :created_by

  def initialize (name, parent_location, created_by)
    @name= name
    @parent_location= parent_location
    @created_at = Time.now
    @created_by = created_by
  end

  def whereami
    return self.name.to_s
  end

  def metadata
    metadata = {:created_at => self.created_at.to_s, :created_by => self.created_by.to_s}
    return metadata
  end

  def type
    return 'folder'
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

end

  folders = []
  files = []
  user = "default_user"
  parent_location=Folder.new "/","",user
  folders.push(parent_location)
  act_location=folders.first
  

loop do 
  print "> "
  input = gets.chomp
  command = input.split /\s/
  case command[0]

    when 'create_folder'
      f = Folder.new command[1].to_s,act_location.name,user
      folders.push(f)

    when 'create_file'
      fl=Filee.new command[1],act_location.name,command[2],user
      files.push(fl)
      # puts fl.name + ' ' + fl.parent_location + ' ' +fl.content.to_s

    when 'show'
      unless command[1].nil? || files.select{|a| a.name==command[1] && a.parent_location==act_location.name}.empty?
        content = (files.select{|a| a.name==command[1] && a.parent_location==act_location.name}).first
        puts content.name+':'
        puts 'Content: '+content.show
      else
        puts 'File doesn\'t exists'
      end

    when 'metadata'
      unless command[1].nil? || files.select{|a| a.name==command[1] && a.parent_location==act_location.name}.empty?
        metadata = (files.select{|a| a.name==command[1] && a.parent_location==act_location.name}).first
        puts metadata.name+':'
        puts 'created_at: '+metadata.metadata[:created_at] + ', created_by: '+metadata.metadata[:created_by]
            else
        puts 'File doesn\'t exists'
      end

    when 'ls'
      act_path_fd = folders.select{|a| a.parent_location==act_location.name} unless folders.select{|a| a.parent_location==act_location.name}.empty?
      act_path_fl = files.select{|a| a.parent_location==act_location.name} unless files.select{|a| a.parent_location==act_location.name}.empty?

      unless act_path_fd.nil? && act_path_fl.nil?
        act_path_fd.each{|a| puts a.name} unless act_path_fd.nil? 
        act_path_fl.each{|a| puts a.name} unless act_path_fl.nil?
      else
        puts 'Empty Folder'
      end

    when 'whereami'
      track=[]

      t = act_location

      until t == nil do
        track.unshift(t.name)
        t = folders.select{|x| x.name==t.parent_location}.first
      end

      puts track.join('/').to_s+'/'

    when 'cd'
      case command[1]
      when '..'
        unless act_location.parent_location==''
          parent_folder = folders.select{|a| a.name==act_location.parent_location}.first
          act_location = parent_folder
        end
      else
        child_folders = folders.select{|a| a.parent_location==act_location.name} unless folders.select{|a| a.parent_location==act_location.name}.empty?
        unless child_folders.nil? || command[1].nil?
          act_location=child_folders.select{|a| a.parent_location==act_location.name && a.name==command[1]}.first
        else
          puts 'Folder not found'
        end
      end 

    when 'destroy'
      # child_folders = folders.select{|a| a.parent_location==act_location.name} unless folders.select{|a| a.parent_location==act_location.name}.empty?
      # child_files = files.select{|a| a.parent_location==act_location.name} unless folders.select{|a| a.parent_location==act_location.name}.empty?
      
      files = files.reject{|a| a.name==command[1]} unless files.select{|a| a.name==command[1] && a.parent_location==act_location.name}.empty?
      folders = folders.reject{|a| a.name==command[1]} unless files.select{|a| a.name==command[1] && a.parent_location==act_location.name}.empty?

      # files = files.reject{|a| a.name==command[1]} unless files.select{|a| a.name==command[1]}.empty?
      # folders = folders.reject{|a| a.name==command[1]} unless folders.select{|a| a.name==command[1]}.empty?

    when 'exit'
      break

    when 'debugger'
      debugger

    when nil

    else
      puts 'Invalid command'
  end
  # break if command == 'exit'
end