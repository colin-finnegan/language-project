class BitwiseAnd
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_bitwise_and(self)
    end
end

class BitwiseOr
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_bitwise_or(self)
    end
end

class BitwiseXor
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_bitwise_xor(self)
    end
end

class BitwiseNot
    attr_reader :operand
    def initialize(operand)
        @operand = operand
    end
    def visit(visitor)
        visitor.visit_bitwise_not(self)
    end
end

class BitwiseLeftShift
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_bitwise_left_shift(self)
    end
end

class BitwiseRightShift
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
    def visit(visitor)
        visitor.visit_bitwise_right_shift(self)
    end
end
