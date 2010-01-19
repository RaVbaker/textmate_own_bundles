# Jump to Class definition in PHP bundle 
# 
# How to install:
#   Create Command bundle in PHP section in Textmate
#   Edit command using configuration info from below
# How to use:
#   While cursor is on class name word or you have selected a class name word press  ⌘F1 to open class definition file. 
# Command Bundle Configuration: 
#   Save: nothing
#   Command(s): <<this whole file>>
#   Input: Selected Text or Word
#   Output: Show as Tool Tip
#   Activation: Key Equivalent:  ⌘F1
#   
#   
#   @author Rafal Piekarski <ravbaker@gmail.com>
#   @version 1.0

ruby 3>&0 <<-'RUBY'
  require ENV["TM_SUPPORT_PATH"] + "/lib/ui.rb"
  require ENV["TM_SUPPORT_PATH"] + "/lib/textmate.rb"

current_class_name = ENV['TM_CURRENT_WORD']
current_class_name = ENV['TM_SELECTED_TEXT'] unless ENV['TM_SELECTED_TEXT'].nil?

current_class_name = current_class_name.gsub('/','_')  # prepare Zend classnames

files = `grep "^class #{current_class_name}[{ ]" -n -m 1 -d recurse --include=*.php #{ENV['TM_PROJECT_DIRECTORY']}`.split("\n")

abort "No includes found for class: #{current_class_name}" if files.empty?

file = ''
if files.size > 1
  abort unless choice = TextMate::UI.menu(files)
  file = files[choice]
else
  file = files.pop
end

file_name = file.split(':').first

if File.exists?(file_name)
  TextMate.go_to :file => file_name
  exit
end

puts "File not found: #{file_name}"
RUBY