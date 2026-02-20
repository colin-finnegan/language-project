class Evaluator
    def initialize()
        @memory = {}
    end

    # Primitives
    def visit_integer_primitive(node)
        return node
    end

    def visit_float_primitive(node)
        return node
    end

    def visit_boolean_primitive(node)
        return node
    end

    def visit_string_primitive(node)
        return node
    end

    def visit_null_primitive(node)
        return node
    end

    # Arithmetic
    def visit_add(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value + right.value)
    end

    def visit_subtract(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value - right.value) 
    end

    def visit_multiply(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value * right.value)
    end

    def visit_divide(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        if right.value == 0
            raise "Runtime Error: Division by 0"

        return wrap_numeric_result(left, right, left.value / right.value)
    end

    def visit_modulo(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value % right.value)
    end

    def visit_exponent(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value ** right.value)
    end

    def visit_negation(node)
        negate = node.operand.visit(self)
        assert_numeric(negate)
        raw_result = -negate.value

        if negate.is_a?(FloatPrimitive)
            return FloatPrimitive.new(raw_value.to_f)
        else
            IntegerPrimitive.new(raw_value.to_i)
        end
    end

    def assert_numeric(node)
        unless node.is_a?(IntegerPrimitive) || node.is_a?(FloatPrimitive)
            raise "Type Error: Expected numeric operand, but got #{node.class}"
        end
    end

    def wrap_numeric_result(left, right, raw_value)
        if left.is_a?(FloatPrimitive) || right.is_a?(FloatPrimitive)
            FloatPrimitive.new(raw_value.to_f)
        else
            IntegerPrimitive.new(raw_value.to_i)
        end
    end

    # Logical
    def visit_and(node)
        left = node.left.visit(self)
        assert_boolean(left)
        if left.value == false
            return left
        
        right = node.right.visit(self)
        assert_boolean(right)

        return right
    end

    def visit_or(node)
        left = node.left.visit(self)
        assert_boolean(left)
        if left.value == true
            return left
        
        right = node.right.visit(self)
        assert_boolean(right)

        return right
    end

    def visit_not(node)
        not_node = node.operand(self)
        assert_boolean(not_node)

        return BooleanPrimitive.new(!not_node.value)
    end

    def assert_boolean(node)
        unless node.is_a?(BooleanPrimitive)
            raise "Type Error: Expected boolean operand, but got #{node.class}"
        end
    end
    
    # Bitwise
    def visit_bitwise_and(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value & right.value
        return IntegerPrimitive.new(raw_result)
    end
    
    def visit_bitwise_or(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value | right.value
        return IntegerPrimitive.new(raw_result)
    end
    
    def visit_bitwise_xor(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value ^ right.value
        return IntegerPrimitive.new(raw_result)
    end
    
    def visit_bitwise_not(node)
        bitwise_not = node.operand.visit(self)
        assert_integer(bitwise_not)

        raw_result = ~bitwise_not.value
        return IntegerPrimitive.new(raw_result)
    end
    
    def visit_bitwise_left_shift(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value << right.value
        return IntegerPrimitive.new(raw_result)
    end
    
    def visit_bitwise_right_shift(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value >> right.value
        return IntegerPrimitive.new(raw_result)
    end

    def assert_integer(node)
        unless node.is_a?(IntegerPrimitive)
            raise "Type Error: Expected integer operand, but got #{node.class}"
        end
    end

    # Relational
    
    
    
    