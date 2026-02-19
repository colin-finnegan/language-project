class FloatToInt
    attr_reader :operand
    def initialize(operand)
        @operand = operand
    end
    def visit(visitor)
        visitor.visit_float_to_int(self)
    end
end

class IntToFloat
    attr_reader :operand
    def initialize(operand)
        @operand = operand
    end
    def visit(visitor)
        visitor.visit_int_to_float(self)
    end
end