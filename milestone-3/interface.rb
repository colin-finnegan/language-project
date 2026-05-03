require 'curses'
require_relative '../milestone-1/nodes'
require_relative '../milestone-2/lexer'
require_relative '../milestone-2/parser'
require_relative '../milestone-1/evaluator'

# Constants
KEY_CTRL_R    = 18
KEY_TAB       = 9
KEY_ENTER     = 10
KEY_RETURN    = 13
KEY_ESC       = 27
KEY_BACKSPACE = 127
KEY_DELETE    = Curses::Key::BACKSPACE

class VariableTracker
  attr_reader :output
  def initialize(variables = {})
    @vars = variables
    @output = [] # Captures 'print' statements
  end
  def defin_function(name, node)
    @functions[name] = node
  end
  def lookup(name)
    #res = @vars[name.to_s] 
    #raise "Undefined variable: #{name}" if res.nil?
    #res
    @functions[name]
  end
  def assign(name, value)
    @vars[name.to_s] = value
  end
  def log_print(val)
    @output << val.to_s
  end
end

def cast_value(val)
  return true if val.downcase == 'true'
  return false if val.downcase == 'false'
  if val.include?('.')
    begin return Float(val); rescue; end
  end
  begin return Integer(val); rescue; end
  val # Default to String
end

def run_engine(source, raw_env, og_labels = [])
  return { val: "", out: "" } if source.nil? || source.strip.empty?
  
  tokens = Lexer.new(source).tokenize
  ast = Parser.new(tokens).parse
  
  # Prepare variables as Primitives
  formatted_env = {}

  # Loop thru table values, convert string to int, wrap in int prim for evaluator
  raw_env.each_with_index do |(name, value), i|
    typed_val = cast_value(value)
    node_class = case typed_val
                 when Integer then IntegerPrimitive
                 when Float   then FloatPrimitive
                 when true, false then BooleanPrimitive
                 when nil     then NullPrimitive
                 else StringPrimitive
                 end

    node = if node_class == NullPrimitive
             node_class.new([0, 0])
           else
             node_class.new(typed_val, [0, 0])
           end
    formatted_env[name.to_s] = node

    if og_labels && og_labels[i]
      formatted_env[og_labels[i].to_s] = node
    end
  end 

  runtime = VariableTracker.new(formatted_env)
  evaluator = Evaluator.new(runtime)
  result_node = ast.visit(evaluator)

  final_val = (result_node && result_node.respond_to?(:value)) ? result_node.value.to_s : "null"

  { val: final_val, out: runtime.output.join(", ") }
  # Displays error message in output window instead of crashing program
  rescue => e
    { val: "Error", out: e.message }
end


def main
  textfile = ARGV[0] || (puts "Usage: ruby interface.rb add.txt"; exit)
  lines = File.readlines(textfile)
  
  #Handle variable number of arguments
  file_args = lines[0].strip.split(/\s+|,/) 
  labels = file_args.each_with_index.map { |_, i| (97 + i).chr }
  secret_code = lines[1..-1].join

  Curses.init_screen
  # Get terminal dimensions
  rows = Curses.lines
  cols = Curses.cols

  # Layout needs at least 30 rows and 80 columns
  if rows < 30 || cols < 80
    Curses.close_screen
    puts "Terminal too small! Current: #{rows}x#{cols}. Need at least 30x80."
    exit
  end 
  Curses.noecho
  Curses.stdscr.keypad(true)
  
  begin
    # Adjusted Heights for larger output space
    table_win  = Curses::Window.new(9, 80, 0, 0)
    editor_win = Curses::Window.new(10, 80, 9, 0)
    output_win = Curses::Window.new(8, 80, 19, 0)
    input_win  = Curses::Window.new(3, 80, 27, 0)

    test_cases = []
    user_code = ""
    all_history = []

    loop do
      # Draw Table
      table_win.clear
      table_win.box("|", "-")
      table_win.setpos(1, 2)
      
      # Align headers and rows
      total_cols = labels.size + 2
      col_width = (75 / total_cols) - 3
      col_width = 6 if col_width < 6
      header_str = labels.map { |l| l.ljust(col_width) }.join(" | ")
      exp_header = "Exp".ljust(col_width)
      act_header = "Act".ljust(col_width)
      table_win.addstr("#{header_str} | #{exp_header} | #{act_header}")
      
      test_cases.each_with_index do |t, i|
        table_win.setpos(2 + i, 2)
        # 1. Truncate Row Inputs
        row_vals = labels.map do |l| 
          t[l].to_s[0...col_width-1].ljust(col_width) 
        end.join(" | ")
        
        # 2. Truncate Expected Result
        exp_display = t['exp'].to_s[0...col_width-1].ljust(col_width)
        
        # 3. Truncate Actual Result
        act_display = t['act'].to_s[0...col_width-1].ljust(col_width)
        
        table_win.addstr("#{row_vals} | #{exp_display} | #{act_display}")
      end
      table_win.refresh

      # Draw Editor (Mystery Box)
      editor_win.clear
      editor_win.box("|", "-")
      editor_win.setpos(0, 2)
      editor_win.addstr(" Mystery Function Box (TAB: Add Case | CTRL+R: Run) ")
      user_code.lines.each_with_index do |line, i|
        (editor_win.setpos(i+1, 2); editor_win.addstr(line.chomp)) if i < 8
      end
      editor_win.refresh

      # Draw Output Panel
      output_win.clear
      output_win.box("|", "-")
      output_win.setpos(0, 2)
      output_win.addstr(" Program Output History ")
      # Put outputs on their own lines
      all_history.last(6).each_with_index do |msg, i|
        output_win.setpos(i + 1, 2)
        output_win.addstr(msg[0..75])
      end
      output_win.refresh

      # Input Logic
      c = editor_win.getch
      case c
      when KEY_ESC, 3 then break
      when KEY_TAB
        new_row = {}
        labels.each do |l|
          input_win.clear; input_win.box("|", "-"); input_win.setpos(1, 2)
          input_win.addstr("Value for #{l}: ")
          input_win.refresh
          Curses.echo
          new_row[l] = input_win.getstr
          Curses.noecho
        end
        
        # Manage case overflow (Limit to 5 cases)
        test_cases.shift if test_cases.size >= 5
        
        res = run_engine(secret_code, new_row, file_args)
        new_row['exp'] = res[:val]
        new_row['act'] = "?"
        test_cases << new_row
        input_win.clear; input_win.refresh
        
      when KEY_CTRL_R
        all_history.clear # Clear for fresh run
        test_cases.each do |t|
          vars = t.select { |k| labels.include?(k) }
          res = run_engine(user_code, vars, file_args)
          t['act'] = res[:val]
          
          display_val = res[:val] == "Error" ? "Error: #{res[:out]}" : res[:val]
          all_history << "[Case #{vars.values.join(',')}]: #{display_val}"
        end
      when KEY_BACKSPACE, 127, 8 # Handle Backspace
        user_code.chop!
      when KEY_ENTER, KEY_RETURN
        user_code += "\n"
      when String
        user_code += c
      when Integer
        user_code += c.chr if c.between?(32, 126)
      end
    end
  ensure
    Curses.close_screen
  end
end

main