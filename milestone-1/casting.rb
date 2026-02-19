class CastingNode
    attr_reader :operand
    def initialize(operand)
        @operand = operand
    end
end

class FloatToInt < CastingNode
    def visit(visitor)
        visitor.visit_float_to_int(self)
    end
end

class IntToFloat < CastingNode
    def visit(visitor)
        visitor.visit_int_to_float(self)
    end
end