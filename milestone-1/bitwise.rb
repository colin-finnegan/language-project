class BitwiseNode < AstNode
    attr_reader :left_operand, :right_operand
    def initialize(left_operand, right_operand)
        @left_operand = left_operand
        @right_operand = right_operand
    end
end

class BitwiseAnd < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_and(self)
    end
end

class BitwiseOr < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_or(self)
    end
end

class BitwiseXor < BitwiseNode
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

class BitwiseLeftShift < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_left_shift(self)
    end
end

class BitwiseRightShift < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_right_shift(self)
    end
end
