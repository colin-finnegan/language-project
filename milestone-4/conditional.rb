class Conditional
  attr_reader :condition, :then_block, :else_block, :indices
 
  def initialize(condition, then_block, else_block, indices)
    @condition  = condition
    @then_block = then_block
    @else_block = else_block  # may be nil
    @indices    = indices
  end
 
  def start_index; @indices[0]; end
  def end_index;   @indices[1]; end
 
  def visit(visitor)
    visitor.visit_conditional(self)
  end
 
  def precedence
    Translator::PRECEDENCE[:conditional]
  end
end