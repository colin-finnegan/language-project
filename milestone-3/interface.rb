require 'curses'
require_relative '../milestone-1/nodes'
require_relative '../milestone-2/lexer'
require_relative '../milestone-2/parser'
require_relative '../milestone-1/evaluator'

class VariableTracker
  attr_reader :output
  def initialize(variables = {})
    @vars = variables
    @output = [] # Captures 'print' statements
  end
  def lookup(name)
    res = @vars[name.to_s] 
    raise "Undefined variable: #{name}" if res.nil?
    res
  end
  def assign(name, value)
    @vars[name.to_s] = value
  end
  def log_print(val)
    @output << val.to_s
  end
end

def run_engine(source, raw_env)
  return { val: "", out: "" } if source.nil? || source.strip.empty?
  
  tokens = Lexer.new(source).tokenize
  ast = Parser.new(tokens).parse
  
  # Prepare variables as Primitives
  formatted_env = {}

  # Loop thru table values, convert string to int, wrap in int prim for evaluator
  raw_env.each do |name, value|
    
    formatted_env[name.to_s] = IntegerPrimitive.new(value.to_i, [0,0])
  end 

  runtime = VariableTracker.new(formatted_env)
  evaluator = Evaluator.new(runtime)
  result_node = ast.visit(evaluator)

  # Check if result node has a value 
  if result_node && result_node.respond_to?(:value)
    final_val = result_node.value.to_s
  else
    final_val = "null"
  end

  # Combine the result and the collected output into a hash for the UI
  { 
    val: final_val,
    out: runtime.output.join(", ") 
  }

  # Displays error message in output window instead of crashing program
  rescue => e
    { val: "Error", out: e.message }
end


def main
  textfile = ARGV[0] || (puts "Usage: ruby interface.rb add.txt"; exit)
  lines = File.readlines(textfile)
  param_line = lines[0].strip
  labels = ["a", "b"]
  secret_code = lines[1..-1].join

  Curses.init_screen
  Curses.noecho
  Curses.stdscr.keypad(true)
  
  begin
    # Window setup to fit your requirements
    table_win  = Curses::Window.new(8, 70, 0, 0)
    editor_win = Curses::Window.new(10, 70, 8, 0)
    output_win = Curses::Window.new(5, 70, 18, 0)
    input_win  = Curses::Window.new(3, 70, 23, 0)

    test_cases = []
    user_code = ""
    last_output = ""

    loop do
      # Draw Table
      table_win.clear
      table_win.box("|", "-")
      table_win.setpos(1, 2)
      table_win.addstr(labels.join(' | ') + " | Expected | Actual")
      test_cases.each_with_index do |t, i|
        table_win.setpos(2 + i, 2)
        row = labels.map { |l| t[l] }.join(' | ')
        table_win.addstr("#{row} | #{t['exp']} | #{t['act']}")
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
      output_win.addstr(" Program Output / Errors ")
      output_win.setpos(2, 2)
      output_win.addstr(last_output[0..65])
      output_win.refresh

      # Input Logic
      c = editor_win.getch
      case c
      when 27, 3 then break
      when 9 # TAB: Add Row
        new_row = {}
        labels.each do |l|
          input_win.clear
          input_win.box("|", "-"); input_win.setpos(1, 2)
          input_win.addstr("Value for #{l}: ")
          input_win.refresh
          Curses.echo
          new_row[l] = input_win.getstr
          Curses.noecho
        end
        # Auto-fill Expected
        res = run_engine(secret_code, new_row)
        new_row['exp'] = res[:val]
        new_row['act'] = "?"
        test_cases << new_row
        input_win.clear
        input_win.refresh
      when 18 # CTRL+R: Run
        all_outputs = [] # Clear outputs for the new run
        test_cases.each do |t|
          vars = t.select { |k| labels.include?(k) }
          res = run_engine(user_code, vars)
          t['act'] = res[:val]
          
          # Collect the output for this specific case
          case_out = res[:out].empty? ? res[:val] : res[:out]
          case_out = "Error: #{res[:out]}" if res[:val] == "Error"
          all_outputs << "[Case #{t.values_at(*labels).join(',')}]: #{case_out}"
        end
        last_output = all_outputs.join(" | ") # Show all results in the panel
      when 127, Curses::Key::BACKSPACE then user_code.chop!
      when 10, 13 then user_code += "\n"
      when String then user_code += c
      when Integer then user_code += c.chr if c.between?(32, 126)
      end
    end
  ensure
    Curses.close_screen
  end
end

main