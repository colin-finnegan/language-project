class And
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_and(self)
    end
end

class Or
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_xor(self)
    end
end

class Or
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_or(self)
    end
end

class Not
    attr_reader :operand
    def initialize(operand)
        @operand = operand
    end
    def visit(visitor)
        visitor.visit_not(self)
    end
end

class LeftShift
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_left_shift(self)
    end
end

class RightShift
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_right_shift(self)
    end
end
