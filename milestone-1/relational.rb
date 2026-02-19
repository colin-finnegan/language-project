class Equals
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end

  def visit(visitor)
    visit.visit_equals(self)
  end
end

class NotEquals
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end

  def visit(visitor)
    visit.visit_equals(self)
  end
end

class LessThan
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end

  def visit(visitor)
    visit.visit_lessThan(self)
  end
end

class GreaterThan
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end

  def visit(visitor)
    visit.visit_greaterThan(self)
  end
end

class LessThanEqual
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end

  def visit(visitor)
    visit.visit_LessThanEqual(self)
  end
end

class GreaterThanEqual
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end

  def visit(visitor)
    visit.visit_greaterThanEqual(self)
  end
end