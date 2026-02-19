# This is the INTERFACE for all the node types to conform to.
# anything that can appear in the syntax tree

#BTW every node must store it's internal data, expose it when needed,
# and allow a visitor to operate on it

class AstNode

# Constructor
  # Initialize the node so that it is the root of its subtree.
  def visit(visitor)
    raise NotImplementedError, "#{self.class} must implement visitor!"
  end
end

