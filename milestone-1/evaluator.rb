class Evaluator
    def initialize(runtime)
        @runtime = runtime
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
        end
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
            return FloatPrimitive.new(raw_result.to_f)
        else
            return IntegerPrimitive.new(raw_result.to_i)
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
        end
        right = node.right.visit(self)
        assert_boolean(right)

        return right
    end

    def visit_or(node)
        left = node.left.visit(self)
        assert_boolean(left)
        if left.value == true
            return left
        end
        right = node.right.visit(self)
        assert_boolean(right)

        return right
    end

    def visit_not(node)
        not_node = node.operand.visit(self)
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
    def visit_equals(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        raw_result = left.value == right.value

        return BooleanPrimitive.new(raw_result)
    end

    def visit_not_equals(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        raw_result = left.value != right.value

        return BooleanPrimitive.new(raw_result)
    end

    def visit_lessThan(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        raw_result = left.value < right.value
        return BooleanPrimitive.new(raw_result)
    end

    def visit_greaterThan(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        raw_result = left.value > right.value
        return BooleanPrimitive.new(raw_result)
    end

    def visit_LessThanEqual(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        raw_result = left.value <= right.value
        return BooleanPrimitive.new(raw_result)
    end

    def visit_greaterThanEqual(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        assert_numeric(left)
        assert_numeric(right)

        raw_result = left.value >= right.value
        return BooleanPrimitive.new(raw_result)
    end

    # Casting
    def visit_float_to_int(node)
        ftoi_node = node.operand.visit(self)
        assert_numeric(ftoi_node)

        return IntegerPrimitive.new(ftoi_node.value.to_i)
    end

    def visit_int_to_float(node)
        itof_node = node.operand.visit(self)
        assert_numeric(itof_node)

        return FloatPrimitive.new(itof_node.value.to_f)
    end

    # rValues
    def visit_variable(node)
        var_name = node.name
        value = @runtime.lookup(var_name)

        return value        
    end

    # Print
    def visit_print(node)
        print_statement = node.operand.visit(self)
        puts print_statement.value

        return NullPrimitive.new
    end

    # Assignment
    def visit_assignment(node)
        value = node.right.visit(self)
        var_name = node.left.is_a?(String) ? node.left : node.left.name

        @runtime.assign(var_name, value)

        return value
    end

    # Block
    def visit_block(node)
        last_result = NullPrimitive.new

        node.statements.each do |statement|
            last_result = statement.visit(self)
        end

        return last_result
    end
  end
