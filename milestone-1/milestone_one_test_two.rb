puts "--- SCRIPT STARTING ---"
require_relative 'nodes' # Replace with your actual file names
require_relative 'evaluator'
require_relative 'runtime'
# require_relative 'translater' # Uncomment when your partner is ready

# 1. Setup
runtime = Runtime.new
evaluator = Evaluator.new(runtime)

def run_test(label, tree, eval_visitor)
  puts "--- Test: #{label} ---"
  # puts "Source: #{tree.visit(translater_visitor)}" # Add this when partner is ready
  
  begin
    result = tree.visit(eval_visitor)
    # Check if result is a primitive node and print its value
    puts "Result: #{result.value} (Type: #{result.class})"
  rescue => e
    puts "Error: #{e.message}"
  end
  puts "\n"
end

# --- REQUIRED EXPRESSIONS ---

# 1. Arithmetic: (7 * 4 + 3) % 12
# Tree: Modulo(Add(Multiply(7, 4), 3), 12)
math_tree = Modulo.new(
  Add.new(
    Multiply.new(IntegerPrimitive.new(7), IntegerPrimitive.new(4)),
    IntegerPrimitive.new(3)
  ),
  IntegerPrimitive.new(12)
)
run_test("Arithmetic (7*4+3)%12", math_tree, evaluator)

# 2. Logic and comparison: !(3.3 > 3.2)
logic_tree = Not.new(
  GreaterThan.new(FloatPrimitive.new(3.3), FloatPrimitive.new(3.2))
)
run_test("Logic !(3.3 > 3.2)", logic_tree, evaluator)

# 3. Bitwise Failure (Purposeful Error): 7.5 << 2
error_tree = BitwiseLeftShift.new(FloatPrimitive.new(7.5), IntegerPrimitive.new(2))
run_test("Bitwise Error (7.5 << 2)", error_tree, evaluator)

# --- REQUIRED MULTI-STATEMENT PROGRAMS ---

# 4. Program: count = 6 << 1; delta = 3; count = count + delta; print count
# This is a Block node containing Assignment and Print nodes
program_tree = Block.new([
  Assignment.new(Variable.new("count"), BitwiseLeftShift.new(IntegerPrimitive.new(6), IntegerPrimitive.new(1))),
  Assignment.new(Variable.new("delta"), IntegerPrimitive.new(3)),
  Assignment.new(
    Variable.new("count"), 
    Add.new(Variable.new("count"), Variable.new("delta"))
  ),
  Print.new(Variable.new("count"))
])
run_test("Multi-statement Program", program_tree, evaluator)

# 5. Type Comparison Error: true >= 10
rel_error = GreaterThanEqual.new(BooleanPrimitive.new(true), IntegerPrimitive.new(10))
run_test("Relational Error (true >= 10)", rel_error, evaluator)