# common root node, so that visit can visit ANY node

class AstNode
  def visit(visitor)
    raise NotImplementedError, "#{self.class} must implement visit"
  end
end