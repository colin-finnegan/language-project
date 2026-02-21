class ArithmeticNode < AstNode
  attr :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end
end

class Add < ArithmeticNode
  def visit(visitor)
    visitor.visit_add(self)
  end

  def precedence
    Translator::PRECEDENCE[:add]
  end
end

class Subtract < ArithmeticNode
  def visit(visitor)
    visitor.visit_subtract(self)
  end

  def precedence
    Translator::PRECEDENCE[:subtract]
  end
end

class Multiply < ArithmeticNode
  def visit(visitor)
    visitor.visit_multiply(self)
  end

  def precedence
    Translator::PRECEDENCE[:multiply]
  end
end

class Divide < ArithmeticNode
  def visit(visitor)
    visitor.visit_divide(self)
  end

  def precedence
    Translator::PRECEDENCE[:divide]
  end
end

class Modulo < ArithmeticNode
  def visit(visitor)
    visitor.visit_modulo(self)
  end

  def precedence
    Translator::PRECEDENCE[:modulo]
  end
end

class Exponent < ArithmeticNode
  def visit(visitor)
    visitor.visit_exponent(self)
  end

  def precedence
    Translator::PRECEDENCE[:exponent]
  end
end

class UnaryNegation
  attr_reader :operand
  def initialize(operand)
    @operand = operand
  end
  def visit(visitor)
    visitor.visit_negation(self)
  end

  def precedence
    Translator::PRECEDENCE[:unaryNegation]
  end
end
