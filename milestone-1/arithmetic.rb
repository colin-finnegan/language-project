class Add
  attr_reader :left, :right
  def initialize(left, right); @left = left; @right = right; end
  def visit(visitor); visitor.visit_add(self); end
end

class Subtract
  attr_reader :left, :right
  def initialize(left, right); @left = left; @right = right; end
  def visit(visitor); visitor.visit_subtract(self); end
end

class Multiply
  attr_reader :left, :right
  def initialize(left, right); @left = left; @right = right; end
  def visit(visitor); visitor.visit_multiply(self); end
end

class Divide
  attr_reader :left, :right
  def initialize(left, right); @left = left; @right = right; end
  def visit(visitor); visitor.visit_divide(self); end
end

class Modulo
  attr_reader :left, :right
  def initialize(left, right); @left = left; @right = right; end
  def visit(visitor); visitor.visit_modulo(self); end
end

class Exponent
  attr_reader :left, :right
  def initialize(left, right); @left = left; @right = right; end
  def visit(visitor); visitor.visit_exponent(self); end
end

class Negation
  attr_reader :operand
  def initialize(operand); @operand = operand; end
  def visit(visitor); visitor.visit_negation(self); end
end
