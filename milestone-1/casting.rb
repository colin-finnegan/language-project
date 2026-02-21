class CastingNode < AstNode
    attr_reader :operand
    def initialize(operand)
        @operand = operand
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