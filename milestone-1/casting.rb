class CastingNode
    attr_reader :operand, :indices
    def initialize(operand, indices)
        @operand = operand
        @indices = indices
    end

    def start_index
        @indices[0]
    end

    def end_index
        @indices[1]
    end
end

class FloatToInt < CastingNode
    def visit(visitor)
        visitor.visit_float_to_int(self)
    end
    def precedence
        Translator::PRECEDENCE[:float2Int]
    end
end

class IntToFloat < CastingNode
    def visit(visitor)
        visitor.visit_int_to_float(self)
    end

    def precedence
        Translator::PRECEDENCE[:int2Float]
    end
end