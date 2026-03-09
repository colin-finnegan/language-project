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
    
    unless result.is_a?(NullPrimitive)
      val = result.respond_to?(:value) ? result.value : result
      puts "RESULT: #{val.inspect}"
    end

  rescue => e
    puts "ERROR:  #{e.message}"
    # puts e.backtrace
  end
end


puts "\n=== ARITHMETIC & BITWISE ==="
run "print 5 + 2"
run "print 10 * 6 - 10 % 4"
run "print (5 + 2) * 3 % 4"
run "print ~6"
run "print 2 ** 9"
run "print 45 & ---(1 + 3)"
run "9 << 1"

puts "\n=== RELATIONAL & LOGICAL ==="
run "print 8 >= 7 + 1"
run "print !!!!false"
run "print true || !false"
run "print (5 > 3) && !(2 > 8)"

puts "\n=== VARIABLE PERSISTENCE ==="
run "x = 5"
run "print x + x * x"
run "x = 999"
run "print x"

puts "\n=== NULL HANDLING ==="
run "print y"