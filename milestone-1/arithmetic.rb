class ArithmeticNode
  attr_reader :left, :right, :indices
  def initialize(left, right, indices)
    @left = left
    @right = right
    @indices = indices
  end

  def start_index
    @indices[0]
  end

  def end_index
    @indices[1]
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
  attr_reader :operand, :indices
  def initialize(operand, indices)
    @operand = operand
    @indices = indices
  end

  def start_index
    indices[0]
  end

  def end_index
    indices[1]
  end

  def visit(visitor)
    visitor.visit_negation(self)
  end

  def precedence
    Translator::PRECEDENCE[:unaryNegation]
  end
end
