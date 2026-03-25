require 'curses'

def main
    textfile = ARGV[0]

    if textfile.nil? || !File.exist?(textfile)
        puts "Error: Please provide a valid file name"
        exit 
    end

    lines = File.readlines(textfile)
    parameters = lines[0].strip
    code = lines[1..-1].join

    Curses.init_screen
    
end

main