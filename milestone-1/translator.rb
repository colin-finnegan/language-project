# two visitors.
# visitor #1 : translates tree to string representation of program in another language
# will result in source code of that language.
# second visit is in evaluate so pay no regard...

# String should show operations & operands in readable manner

# The translate will walk the tree and produce a string representation of that structure.

# recursively walks, builds strings, combines child results

class Translator
  PRECEDENCE = {
  block:          1,
  print:          2,
  assignment:     3,
  logOR:          4,
  logAND:         5,
  logNOT:         6,
  bitOR:          7,
  bitXOR:         8,
  bitAND:         9,
  bitNOT:         10,
  equals:         11,
  notEquals:      11,
  lessThan:       12,
  greaterThan:    12,
  lessEqual:      12,
  greaterEqual:   12,
  leftShift:      13,
  rightShift:     13,
  add:            14,
  subtract:       14,
  multiply:       15,
  divide:         15,
  modulo:         15,
  exponent:       16,
  unaryNegation:  17,
  int2Float:      18,
  float2Int:      18,
  rvalue:         19,
  integer:        20,
  float:          20,
  boolean:        20,
  string:         20,
  null:           20
  }

  def parenthesize(child_node, parentPrecedence)
    child_str = child_node.visit(self)

    if child_node.precedence < parentPrecedence
      "(#{child_str})"
    else
      child_str
    end
  end

  # entry point
  def translate(node)
    node.visit(self)
  end

  # Primitives :

  def visit_integer_primitive(node)
    node.value.to_s
  end

  def visit_float_primitive(node)
    node.value.to_s
  end

  def visit_boolean_primitive(node)
    node.value.to_s
  end

  def visit_string_primitive(node)
    "\"#{node.value}\""
  end

  def visit_null_primitive(node)
    "null"
  end

  # Arithmetic :

  def visit_add(node)
    left_str = parenthesize(node.left, PRECEDENCE[:add])
    right_str = parenthesize(node.right, PRECEDENCE[:add])
    "#{left_str} + #{right_str}"
  end

  def visit_subtract(node)
    left_str = parenthesize(node.left, PRECEDENCE[:subtract])
    right_str = parenthesize(node.right, PRECEDENCE[:subtract])
    "#{left_str} - #{right_str}"
  end

  def visit_multiply(node)
    left_str = parenthesize(node.left, PRECEDENCE[:multiply])
    right_str = parenthesize(node.right, PRECEDENCE[:multiply])
    "#{left_str} * #{right_str}"
  end

  def visit_divide(node)
    left_str = parenthesize(node.left, PRECEDENCE[:divide])
    right_str = parenthesize(node.right, PRECEDENCE[:divide])
    "#{left_str} / #{right_str}"
  end

  def visit_modulo(node)
    left_str = parenthesize(node.left, PRECEDENCE[:modulo])
    right_str = parenthesize(node.right, PRECEDENCE[:modulo])
    "#{left_str} % #{right_str}"
  end

  def visit_exponent(node)
    left_str = parenthesize(node.left, PRECEDENCE[:exponent])
    right_str = parenthesize(node.right, PRECEDENCE[:exponent])
    "#{left_str} ** #{right_str}"
  end
  
  def visit_negation(node)
    str = parenthesize(node.operand, PRECEDENCE[:unaryNegation])
    "-#{str}"
  end

  # bitwise

  def visit_bitwise_and(node)
    left_str = parenthesize(node.left, PRECEDENCE[:bitAND])
    right_str = parenthesize(node.right, PRECEDENCE[:bitAND])
    "#{left_str} & #{right_str}"
  end

  def visit_bitwise_or(node)
    left_str = parenthesize(node.left, PRECEDENCE[:bitOR])
    right_str = parenthesize(node.right, PRECEDENCE[:bitOR])
    "#{left_str} | #{right_str}"
  end

  def visit_bitwise_xor(node)
    left_str = parenthesize(node.left, PRECEDENCE[:bitXOR])
    right_str = parenthesize(node.right, PRECEDENCE[:bitXOR])
    "#{left_str} ^ #{right_str}"
  end

  def visit_bitwise_not(node)
    str = parenthesize(node.operand, PRECEDENCE[:bitNOT])
    "~#{str}"
  end

  def visit_bitwise_left_shift(node)
    left_str = parenthesize(node.left, PRECEDENCE[:leftShift])
    right_str = parenthesize(node.right, PRECEDENCE[:leftShift])
    "#{left_str} << #{right_str}"
  end

  def visit_bitwise_right_shift(node)
    left_str = parenthesize(node.left, PRECEDENCE[:rightShift])
    right_str = parenthesize(node.right, PRECEDENCE[:rightShift])
    "#{left_str} >> #{right_str}"
  end

  # logical

  def visit_and(node)
    left_str = parenthesize(node.left, PRECEDENCE[:logAND])
    right_str = parenthesize(node.right, PRECEDENCE[:logAND])
    "#{left_str} && #{right_str}"
  end

  def visit_or(node)
    left_str = parenthesize(node.left, PRECEDENCE[:logOR])
    right_str = parenthesize(node.right, PRECEDENCE[:logOR])
    "#{left_str} || #{right_str}"
  end

  def visit_not(node)
    str = parenthesize(node.operand, PRECEDENCE[:logNOT])
    "!#{str}"
  end

  # relational

  def visit_equals(node)
    left_str = parenthesize(node.left, PRECEDENCE[:equals])
    right_str = parenthesize(node.right, PRECEDENCE[:equals])
    "#{left_str} == #{right_str}"
  end

  def visit_not_equals(node)
    left_str = parenthesize(node.left, PRECEDENCE[:notEquals])
    right_str = parenthesize(node.right, PRECEDENCE[:notEquals])
    "#{left_str} != #{right_str}"
  end

  def visit_lessThan(node)
    left_str = parenthesize(node.left, PRECEDENCE[:lessThan])
    right_str = parenthesize(node.right, PRECEDENCE[:lessThan])
    "#{left_str} < #{right_str}"
  end

  def visit_greaterThan(node)
    left_str = parenthesize(node.left, PRECEDENCE[:greaterThan])
    right_str = parenthesize(node.right, PRECEDENCE[:greaterThan])
    "#{left_str} > #{right_str}"
  end

  def visit_LessThanEqual(node)
    left_str = parenthesize(node.left, PRECEDENCE[:lessEqual])
    right_str = parenthesize(node.right, PRECEDENCE[:lessEqual])
    "#{left_str} <= #{right_str}"
  end

  def visit_greaterThanEqual(node)
    left_str = parenthesize(node.left, PRECEDENCE[:greaterEqual])
    right_str = parenthesize(node.right, PRECEDENCE[:greaterEqual])
    "#{left_str} >= #{right_str}"
  end

  # assignment

  def visit_assignment(node)
    left_str = node.left.visit(self)
    right_str = parenthesize(node.right, PRECEDENCE[:assignment])
    "#{left_str} = #{right_str}"
  end

  # block - go through each statement and join w/ newlines

  def visit_block(node)
    node.statements.map { |statement| statement.visit(self) }.join("\n")
  end

  # print

  def visit_print(node)
    str = node.operand.visit(self)
    "print #{str}"
  end

  # rvalues

  def visit_variable(node)
    str = node.name.to_s
    "#{str}"
  end

  # casting

  def visit_float_to_int(node)
    str = parenthesize(node.operand, PRECEDENCE[:float2Int])
    "int#{str}"
  end

  def visit_int_to_float(node)
    str = parenthesize(node.operand, PRECEDENCE[:int2Float])
    "float#{str}"
  end


end