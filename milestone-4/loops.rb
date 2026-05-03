class WhileLoop
  attr_reader :condition, :body, :indices
 
  def initialize(condition, body, indices)
    @condition = condition
    @body      = body
    @indices   = indices
  end
 
  def start_index; @indices[0]; end
  def end_index;   @indices[1]; end
 
  def visit(visitor)
    visitor.visit_while(self)
  end
 
  def precedence
    Translator::PRECEDENCE[:while_loop]
  end
end
 
class ForEach
  attr_reader :variable, :start_expr, :end_expr, :body, :indices
 
  # variable is a String (the loop variable name)
  def initialize(variable, start_expr, end_expr, body, indices)
    @variable   = variable
    @start_expr = start_expr
    @end_expr   = end_expr
    @body       = body
    @indices    = indices
  end
 
  def start_index; @indices[0]; end
  def end_index;   @indices[1]; end
 
  def visit(visitor)
    visitor.visit_foreach(self)
  end
 
  def precedence
    Translator::PRECEDENCE[:for_each]
  end
end