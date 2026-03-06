class PrimitiveNode
    attr_reader :value
    def initialize(value)
    @value = value
    end
end

class IntegerPrimitive < PrimitiveNode
    def visit(visitor)
        visitor.visit_integer_primitive(self)
    end

    def precedence
        Translator::PRECEDENCE[:integer]
    end
end

class FloatPrimitive < PrimitiveNode
    def visit(visitor)
        visitor.visit_float_primitive(self)
    end

    def precedence
        Translator::PRECEDENCE[:float]
    end
end

class BooleanPrimitive < PrimitiveNode
    def visit(visitor)
        visitor.visit_boolean_primitive(self)
    end

    def precedence
        Translator::PRECEDENCE[:boolean]
    end
end

class StringPrimitive < PrimitiveNode
    def visit(visitor)
        visitor.visit_string_primitive(self)
    end

    def precedence
        Translator::PRECEDENCE[:string]
    end
end

class NullPrimitive < PrimitiveNode
    def initialize
        @value = nil
    end
    
    def visit(visitor)
        visitor.visit_null_primitive(self)
    end

    def precedence
        Translator::PRECEDENCE[:null]
    end
end
