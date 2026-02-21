#superclass
class RelationOperator < AstNode
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end
end

class Equals < RelationOperator
  def visit(visitor)
    visitor.visit_equals(self)
  end

  def precedence
    Translator::PRECEDENCE[:equals]
  end
end

class NotEquals < RelationOperator
  def visit(visitor)
    visitor.visit_not_equals(self)
  end

  def precedence
    Translator::PRECEDENCE[:notEquals]
  end
end

class LessThan < RelationOperator
  def visit(visitor)
    visitor.visit_lessThan(self)
  end

  def precedence
    Translator::PRECEDENCE[:lessThan]
  end
end

class GreaterThan < RelationOperator
  def visit(visitor)
    visitor.visit_greaterThan(self)
  end

  def precedence
    Translator::PRECEDENCE[:greaterThan]
  end
end

class LessThanEqual < RelationOperator
  def visit(visitor)
    visitor.visit_LessThanEqual(self)
  end

  def precedence
    Translator::PRECEDENCE[:lessEqual]
  end
end

class GreaterThanEqual < RelationOperator
  def visit(visitor)
    visitor.visit_greaterThanEqual(self)
  end

  def precedence
    Translator::PRECEDENCE[:greaterEqual]
  end
end