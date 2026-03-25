require_relative '../milestone-1/nodes'
require_relative '../milestone-1/runtime'
require_relative '../milestone-1/evaluator'
require_relative 'token'
require_relative 'Lexer'
require_relative 'Parser'

@runtime = Runtime.new
@evaluator = Evaluator.new(@runtime)

def run(source)
  puts "--------------------------------------------------"
  puts "INPUT:  #{source.inspect}"
  
  begin
    tokens = Lexer.new(source).tokenize
    
    parser = Parser.new(tokens)
    ast = parser.parse

    result = ast.visit(@evaluator)
    
    if result
      val = result.respond_to?(:value) ? result.value : result
      # If val is nil, we want to see "RESULT: null" 
      if result.is_a?(NullPrimitive)
        puts "RESULT: null"
      else
        puts "RESULT: #{val.inspect}"
      end
    end

  rescue => e
    puts "ERROR:  #{e.message}"
    # puts e.backtrace
  end
end


puts "\n---- ARITHMETIC ----"
run <<~PROG
  print 5 + 2
  print 10 * 6 - 10 % 4
  print (5 + 2) * 3 % 4
  print ~6
  print 2 ** 9
  print 45 & ---(1 + 3)
  9 << 1
PROG
# = 18 

puts "\n---- LOGIC ----"
run <<~PROG
  print 8 >= 7 + 1
  print !!!!false
  print true || !false
  print (5 > 3) && !(2 > 8)
PROG
# = True

puts "\n---- VARIABLES ----"
run <<~PROG
  x = 5
  print x + x * x
  x = 999
  print x
PROG
# = 999


puts "\n=== NULL HANDLING==="
run "print y"