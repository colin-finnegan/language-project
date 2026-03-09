class Assignment
  attr_reader :left, :right, :indices
  def initialize(left, right, indices)
    @left = left # rvalue node
    @right = right
    @indices = indices
  end

  def start_index
    @indices[0]
  end

  def end_index
    @indices[1]
  end

  def visit(visitor)
    visitor.visit_assignment(self)
  end

  def precedence
    Translator::PRECEDENCE[:assignment]
  end
end