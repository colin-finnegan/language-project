class Assignment < AstNode
  attr_reader :left, :right
  def initialize(left, right)
    @left = left # rvalue node
    @right = right
  end

  def visit(visitor)
    visitor.visit_assignment(self)
  end
end