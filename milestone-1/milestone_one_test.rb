require_relative "translator"
require_relative "evaluator"
require_relative "nodes"
require_relative "runtime"

translator = Translator.new
runtime = Runtime.new
evaluator = Evaluator.new(runtime)
# puts translator.translate(ast)

def run_test(name, ast, translator, evaluator)
  puts "=============================="
  puts name
  puts "---- Translation ----"
  puts translator.translate(ast)
  puts "---- Evaluation ----"
  result = ast.visit(evaluator)
  puts "Result: #{result.value}" unless result.is_a?(NullPrimitive)
  puts
end

# arithmetic (7 * 4 + 3) % 12 :


arith_ast = Modulo.new(
  Add.new(
    Multiply.new(
      IntegerPrimitive.new(7),
      IntegerPrimitive.new(4)
    ),
    IntegerPrimitive.new(3)
  ),
  IntegerPrimitive.new(12)
)

run_test("Arithmetic", arith_ast, translator, evaluator)

# arith. negation and rvalues a * b :

runtime.assign("a", IntegerPrimitive.new(2))
runtime.assign("b", IntegerPrimitive.new(3))

ab_ast = Multiply.new(
  Variable.new("a"),
  Variable.new("b")
)

run_test("a * b", ab_ast, translator, evaluator)

# rvalue lookup and shift  i << 3:

runtime.assign("i", IntegerPrimitive.new(4))

shift_ast = BitwiseLeftShift.new(
  Variable.new("i"),
  IntegerPrimitive.new(3)
)

run_test("i << 3", shift_ast, translator, evaluator)

# rvalue lookup and comparison  j == j + 0 :

runtime.assign("j", IntegerPrimitive.new(10))

compare_ast = Equals.new(
  Variable.new("j"),
  Add.new(
    Variable.new("j"),
    IntegerPrimitive.new(0)
  )
)

run_test("j == j + 0", compare_ast, translator, evaluator)

#logic and comparison !(3.3 > 3.2):

logic_ast = Not.new(
  GreaterThan.new(
    FloatPrimitive.new(3.3),
    FloatPrimitive.new(3.2)
  )
)

run_test("!(3.3 > 3.2)", logic_ast, translator, evaluator)

# double negation --(6 * 8) :

double_neg_ast = UnaryNegation.new(
  UnaryNegation.new(
    Multiply.new(
      IntegerPrimitive.new(6),
      IntegerPrimitive.new(8)
    )
  )
)

run_test("--(6 * 8)", double_neg_ast, translator, evaluator)

#bitwise operations ~5 | 8 :

bitwise_ast = BitwiseOr.new(
  BitwiseNot.new(IntegerPrimitive.new(5)),
  BitwiseNot.new(IntegerPrimitive.new(8))
)

run_test("~5 | ~8", bitwise_ast, translator, evaluator)

# casting float(7) / 2 :

cast_ast = Divide.new(
  IntToFloat.new(IntegerPrimitive.new(7)),
  IntegerPrimitive.new(2)
)

run_test("float(7) / 2", cast_ast, translator, evaluator)

# assignment n = 9 & 3 :

assign_ast = Assignment.new(
  Variable.new("n"),
  BitwiseAnd.new(
    IntegerPrimitive.new(9),
    IntegerPrimitive.new(3)
  )
)

run_test("n = 9 & 3", assign_ast, translator, evaluator)

# multi - statements :

puts "Multi-statement Program 1"

prog1 = Block.new([
  Assignment.new(
    Variable.new("x"),
    IntegerPrimitive.new(17)
  ),
  Print.new(
    Variable.new("x")
  )
])

puts translator.translate(prog1)
prog1.visit(evaluator)


puts "Multi-statement Program 2"

prog2 = Block.new([
  Assignment.new(
    Variable.new("count"),
    BitwiseLeftShift.new(
      IntegerPrimitive.new(6),
      IntegerPrimitive.new(1)
    )
  ),
  Assignment.new(
    Variable.new("delta"),
    IntegerPrimitive.new(3)
  ),
  Assignment.new(
    Variable.new("count"),
    Add.new(
      Variable.new("count"),
      Variable.new("delta")
    )
  ),
  Print.new(
    Variable.new("count")
  )
])

puts translator.translate(prog2)
prog2.visit(evaluator)


puts "Multi-statement Program 3"

prog3 = Block.new([
  Assignment.new(
    Variable.new("n"),
    IntegerPrimitive.new(18)
  ),
  Print.new(
    LessThanEqual.new(
      Variable.new("n"),
      IntegerPrimitive.new(18)
    )
  ),
  Print.new(
    And.new(
      LessThanEqual.new(
        IntegerPrimitive.new(13),
        Variable.new("n")
      ),
      LessThanEqual.new(
        Variable.new("n"),
        IntegerPrimitive.new(16)
      )
    )
  ),
  Print.new(
    UnaryNegation.new(
      Exponent.new(
        Variable.new("n"),
        IntegerPrimitive.new(2)
      )
    )
  )
])

puts translator.translate(prog3)
prog3.visit(evaluator)
