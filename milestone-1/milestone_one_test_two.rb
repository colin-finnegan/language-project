puts "--- SCRIPT STARTING ---"
require_relative 'nodes'
require_relative 'primitive'
require_relative 'evaluator'
require_relative 'runtime'

runtime = Runtime.new
evaluator = Evaluator.new(runtime)

def run_test(label, tree, eval_visitor)
  puts "--- Test: #{label} ---"
  begin
    result = tree.visit(eval_visitor)
    # Using inspect to show 'nil' for NullPrimitive
    puts "Result: #{result.value.inspect} (Type: #{result.class})"
  rescue => e
    puts "Error: #{e.message}"
    puts "Location: #{e.backtrace.first}"
  end
  puts "\n"
end

# --- 1. INDIVIDUAL EXPRESSIONS ---

# Arithmetic: (7 * 4 + 3) % 12
run_test("Arithmetic (7*4+3)%12", 
  Modulo.new(Add.new(Multiply.new(IntegerPrimitive.new(7), IntegerPrimitive.new(4)), IntegerPrimitive.new(3)), IntegerPrimitive.new(12)), 
  evaluator)

# Arithmetic negation and rvalues: a * b
runtime.assign("a", IntegerPrimitive.new(10))
runtime.assign("b", IntegerPrimitive.new(5))
run_test("Rvalues a * b", Multiply.new(Variable.new("a"), Variable.new("b")), evaluator)

# Rvalue lookup and shift: i << 3
runtime.assign("i", IntegerPrimitive.new(2))
run_test("Lookup and shift i << 3", BitwiseLeftShift.new(Variable.new("i"), IntegerPrimitive.new(3)), evaluator)

# Rvalue lookup and comparison: j == j + 0
runtime.assign("j", IntegerPrimitive.new(100))
run_test("Comparison j == j + 0", Equals.new(Variable.new("j"), Add.new(Variable.new("j"), IntegerPrimitive.new(0))), evaluator)

# Logic and comparison: !(3.3 > 3.2)
run_test("Logic !(3.3 > 3.2)", Not.new(GreaterThan.new(FloatPrimitive.new(3.3), FloatPrimitive.new(3.2))), evaluator)

# Double negation: --(6 * 8)
run_test("Double negation --(6 * 8)", UnaryNegation.new(UnaryNegation.new(Multiply.new(IntegerPrimitive.new(6), IntegerPrimitive.new(8)))), evaluator)

# Bitwise operations: ~5 | ~8
run_test("Bitwise ~5 | ~8", BitwiseOr.new(BitwiseNot.new(IntegerPrimitive.new(5)), BitwiseNot.new(IntegerPrimitive.new(8))), evaluator)

# Casting: float(7) / 2
run_test("Casting float(7) / 2", Divide.new(IntToFloat.new(IntegerPrimitive.new(7)), IntegerPrimitive.new(2)), evaluator)

# Assignment: n = 9 & 3
run_test("Assignment n = 9 & 3", Assignment.new(Variable.new("n"), BitwiseAnd.new(IntegerPrimitive.new(9), IntegerPrimitive.new(3))), evaluator)


# --- 2. MULTI-STATEMENT PROGRAMS ---

# Program 1: x = 17; print x
run_test("Program: x = 17; print x", Block.new([
  Assignment.new(Variable.new("x"), IntegerPrimitive.new(17)),
  Print.new(Variable.new("x"))
]), evaluator)

# Program 2: count = 6 << 1; delta = 3; count = count + delta; print count
run_test("Program: count = 6 << 1...", Block.new([
  Assignment.new(Variable.new("count"), BitwiseLeftShift.new(IntegerPrimitive.new(6), IntegerPrimitive.new(1))),
  Assignment.new(Variable.new("delta"), IntegerPrimitive.new(3)),
  Assignment.new(Variable.new("count"), Add.new(Variable.new("count"), Variable.new("delta"))),
  Print.new(Variable.new("count"))
]), evaluator)

# Program 3: n = 18; print n <= 18; print 13 <= n && n <= 16; print -(n ** 2)
prog3_statements = [
  Assignment.new(Variable.new("n"), IntegerPrimitive.new(18)),
  Print.new(LessThanEqual.new(Variable.new("n"), IntegerPrimitive.new(18))),
  Print.new(
    And.new(
      LessThanEqual.new(IntegerPrimitive.new(13), Variable.new("n")), 
      LessThanEqual.new(Variable.new("n"), IntegerPrimitive.new(16))
    )
  ),
  Print.new(UnaryNegation.new(Exponent.new(Variable.new("n"), IntegerPrimitive.new(2))))
]
run_test("Program: n = 18 and logic", Block.new(prog3_statements), evaluator)


# --- 3. TYPECHECK FAILURES ---

run_test("Fail: 7.5 << 2", 
  BitwiseLeftShift.new(FloatPrimitive.new(7.5), IntegerPrimitive.new(2)), 
  evaluator)

run_test("Fail: true >= 10", 
  GreaterThanEqual.new(BooleanPrimitive.new(true), IntegerPrimitive.new(10)), 
  evaluator)

run_test("Fail: 'fooo' / 3", 
  Divide.new(StringPrimitive.new("fooo"), IntegerPrimitive.new(3)), 
  evaluator)