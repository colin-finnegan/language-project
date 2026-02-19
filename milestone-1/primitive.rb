class IntegerPrimitive
    attr_reader :value
    def initialize(value);
    @value = value; end
    def visit(visitor); visitor.visit_integer_primitive(self); end
end

class FloatPrimitive
    attr_reader :value
    def initialize(value);
    @value = value; end
    def visit(visitor); visitor.visit_float_primitive(self); end
end

class BooleanPrimitive
    attr_reader :value
    def initialize(value);
    @value = value; end
    def visit(visitor); visitor.visit_boolean_primitive(self); end
end

class StringPrimitive
    attr_reader :value
    def initialize(value);
    @value = value; end
    def visit(visitor); visitor.visit_string_primitive(self); end
end

class NullPrimitive
    attr_reader :value
    def initialize(value);
    @value = value; end
    def visit(visitor); visitor.visit_null_primitive(self); end
end
