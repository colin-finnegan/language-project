# Thrown by Return nodes to unwind the call stack back to the caller.
# This is intentional control flow, not an error.
class ReturnException < StandardError
  attr_reader :value
  def initialize(value)
    @value = value
  end
end
 
class FunctionDef
  attr_reader :name, :params, :body, :indices
 
  # params is an Array of String parameter names
  def initialize(name, params, body, indices)
    @name    = name
    @params  = params
    @body    = body
    @indices = indices
  end
 
  def start_index; @indices[0]; end
  def end_index;   @indices[1]; end
 
  def visit(visitor)
    visitor.visit_function_def(self)
  end
 
  def precedence
    Translator::PRECEDENCE[:function_def]
  end
end
 
class FunctionCall
  attr_reader :name, :args, :indices
 
  # args is an Array of expression nodes (actual parameters)
  def initialize(name, args, indices)
    @name    = name
    @args    = args
    @indices = indices
  end
 
  def start_index; @indices[0]; end
  def end_index;   @indices[1]; end
 
  def visit(visitor)
    visitor.visit_function_call(self)
  end
 
  def precedence
    Translator::PRECEDENCE[:function_call]
  end
end
 
class Return
  attr_reader :expression, :indices
 
  def initialize(expression, indices)
    @expression = expression
    @indices    = indices
  end
 
  def start_index; @indices[0]; end
  def end_index;   @indices[1]; end
 
  def visit(visitor)
    visitor.visit_return(self)
  end
 
  def precedence
    Translator::PRECEDENCE[:return_stmt]
  end
end