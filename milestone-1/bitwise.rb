class BitwiseNode
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

class BitwiseAnd < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_and(self)
    end

    def precedence
        Translator::PRECEDENCE[:bitAND]
    end
end

class BitwiseOr < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_or(self)
    end

    def precedence
        Translator::PRECEDENCE[:bitOR]
    end
end

class BitwiseXor < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_xor(self)
    end

    def precedence
        Translator::PRECEDENCE[:bitXOR]
    end
end

class BitwiseNot
    attr_reader :operand, :indices
    def initialize(operand, indices)
        @operand = operand
        @indices = indices
    end
    def visit(visitor)
        visitor.visit_bitwise_not(self)
    end

    def start_index
        @indices[0]  
    end

    def end_index
        @indices[1]  
    end

    def precedence
        Translator::PRECEDENCE[:bitNOT]
    end
end

class BitwiseLeftShift < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_left_shift(self)
    end

    def precedence
        Translator::PRECEDENCE[:leftShift]
    end
end

class BitwiseRightShift < BitwiseNode
    def visit(visitor)
        visitor.visit_bitwise_right_shift(self)
    end

    def precedence
        Translator::PRECEDENCE[:rightShift]
    end
end
