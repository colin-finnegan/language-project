class Assignment
  attr_reader :left, :right
  def initialize(left, right)
    @left = left # rvalue node
    @right = right
  end

  def visit(visitor)
    visitor.visit_assignment(self)
  end

  def precedence
    Translator::PRECEDENCE[:assignment]
  end
end