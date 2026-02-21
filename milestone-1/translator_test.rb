require_relative "translator"
require_relative "nodes"


ast = Add.new(
  IntegerPrimitive.new(2),
  Multiply.new(
    IntegerPrimitive.new(3),
    IntegerPrimitive.new(4)
  )
)

translator = Translator.new
puts translator.translate(ast)

parent_ast = Multiply.new(
  Add.new(
    IntegerPrimitive.new(2),
    IntegerPrimitive.new(3)
  ),
  IntegerPrimitive.new(4)
)

puts translator.translate(parent_ast)

assigning_ast = Assignment.new(
  Variable.new("x"),
  Add.new(
    IntegerPrimitive.new(1),
    IntegerPrimitive.new(2)
  )
)

puts translator.translate(assigning_ast)

block_ast = Block.new([
  Assignment.new(
    Variable.new("hi"),
    IntegerPrimitive.new(5)
  ),
  Print.new(
    Variable.new("hi")
  )
])

puts translator.translate(block_ast)

f_to_i_ast = FloatToInt.new(
  Add.new(
    FloatPrimitive.new(3.2),
    FloatPrimitive.new(4.8)
  )
)

puts translator.translate(f_to_i_ast)

