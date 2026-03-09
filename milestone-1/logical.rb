class LogicalNode
    attr_reader :left, :right, :indices
    def initialize(left, right, indices)
        @left = left
        @right = right
        @indices = indices
    end

    def start_index
        @indices[0]
    end

    def end_index
        @indices[1]
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
    def initialize(operand, indices)
        @operand = operand
        @indices = indices
    end

    def visit(visitor)
        visitor.visit_not(self)
    end

    def precedence
    Translator::PRECEDENCE[:logNOT]
    end
end
