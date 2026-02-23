class LogicalNode < AstNode
    attr_reader :left, :right
    def initialize(left, right)
        @left = left
        @right = right
    end
end

class And < LogicalNode
    def visit(visitor)
        visitor.visit_and(self)
    end

    def precedence
        Translator::PRECEDENCE[:logAND]
    end
end

class Or < LogicalNode
    def visit(visitor)
        visitor.visit_or(self)
    end
    def precedence
        Translator::PRECEDENCE[:logOR]
    end
end

class Not < LogicalNode
    attr_reader :operand
    def initialize(operand)
        @operand = operand
    end
    def visit(visitor)
        visitor.visit_not(self)
    end

    def precedence
    Translator::PRECEDENCE[:logNOT]
  end
end
