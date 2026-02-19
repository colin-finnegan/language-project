class relationOperator
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end
end

class Equals < relationOperator
  def visit(visitor)
    visitor.visit_equals(self)
  end
end

class NotEquals < relationOperator
  def visit(visitor)
    visitor.visit_equals(self)
  end
end

class LessThan < relationOperator
  def visit(visitor)
    visitor.visit_lessThan(self)
  end
end

class GreaterThan < relationOperator
  def visit(visitor)
    visitor.visit_greaterThan(self)
  end
end

class LessThanEqual < relationOperator
  def visit(visitor)
    visitor.visit_LessThanEqual(self)
  end
end

class GreaterThanEqual < relationOperator
  def visit(visitor)
    visitor.visit_greaterThanEqual(self)
  end
end