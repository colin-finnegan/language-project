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

        return left if is_null?(left)
        return right if is_null?(right)

        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value + right.value)
    end

    def visit_subtract(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value - right.value) 
    end

    def visit_multiply(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value * right.value)
    end

    def visit_divide(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        
        return left if is_null?(left)
        return right if is_null?(right)
        
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
        
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value % right.value)
    end

    def visit_exponent(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_numeric(left)
        assert_numeric(right)

        return wrap_numeric_result(left, right, left.value ** right.value)
    end

    def visit_negation(node)
        negate = node.operand.visit(self)

        return negate if is_null?(negate)

        assert_numeric(negate)
        raw_result = -negate.value

        if negate.is_a?(FloatPrimitive)
            return FloatPrimitive.new(raw_result.to_f, negate.indices)
        else
            return IntegerPrimitive.new(raw_result.to_i, negate.indices)
        end
    end

    def assert_numeric(node)
        unless node.is_a?(IntegerPrimitive) || node.is_a?(FloatPrimitive)
            raise "Type Error: Expected numeric operand, but got #{node.class}"
        end
    end

    def wrap_numeric_result(left, right, raw_value)
        indices = [left.start_index, right.end_index]
        if left.is_a?(FloatPrimitive) || right.is_a?(FloatPrimitive)
            FloatPrimitive.new(raw_value.to_f, indices)
        else
            IntegerPrimitive.new(raw_value.to_i, indices)
        end
    end

    def is_null?(node)
        node.is_a?(NullPrimitive)
    end

    # Logical
    def visit_and(node)
        left = node.left.visit(self)
        return left if is_null?(left)
        assert_boolean(left)
        if left.value == false
            return left
        end
        right = node.right.visit(self)
        return right if is_null?(right)
        assert_boolean(right)

        return right
    end

    def visit_or(node)
        left = node.left.visit(self)
        return left if is_null?(left)
        assert_boolean(left)
        if left.value == true
            return left
        end
        right = node.right.visit(self)
        return right if is_null?(right)
        assert_boolean(right)

        return right
    end

    def visit_not(node)
        not_node = node.operand.visit(self)

        return not_node if is_null?(not_node)

        assert_boolean(not_node)

        return BooleanPrimitive.new(!not_node.value, node.indices)
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
         
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value & right.value
        return IntegerPrimitive.new(raw_result, node.indices)
    end
    
    def visit_bitwise_or(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
         
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value | right.value
        return IntegerPrimitive.new(raw_result, node.indices)
    end
    
    def visit_bitwise_xor(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
         
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value ^ right.value
        return IntegerPrimitive.new(raw_result, node.indices)
    end
    
    def visit_bitwise_not(node)
        bitwise_not = node.operand.visit(self)
        return bitwise_not if is_null?(bitwise_not)
        assert_integer(bitwise_not)

        raw_result = ~bitwise_not.value
        return IntegerPrimitive.new(raw_result, node.indices)
    end
    
    def visit_bitwise_left_shift(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
         
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value << right.value
        return IntegerPrimitive.new(raw_result, node.indices)
    end
    
    def visit_bitwise_right_shift(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
         
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_integer(left)
        assert_integer(right)

        raw_result = left.value >> right.value
        return IntegerPrimitive.new(raw_result, node.indices)
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

        return left if is_null?(left)
        return right if is_null?(right)
        
        raw_result = left.value == right.value

        return BooleanPrimitive.new(raw_result, node.indices)
    end

    def visit_not_equals(node)
        left = node.left.visit(self)
        right = node.right.visit(self)

        return left if is_null?(left)
        return right if is_null?(right)
        
        raw_result = left.value != right.value

        return BooleanPrimitive.new(raw_result, node.indices)
    end

    def visit_lessThan(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_numeric(left)
        assert_numeric(right)

        raw_result = left.value < right.value
        return BooleanPrimitive.new(raw_result, node.indices)
    end

    def visit_greaterThan(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_numeric(left)
        assert_numeric(right)

        raw_result = left.value > right.value
        return BooleanPrimitive.new(raw_result, node.indices)
    end

    def visit_LessThanEqual(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_numeric(left)
        assert_numeric(right)

        raw_result = left.value <= right.value
        return BooleanPrimitive.new(raw_result, node.indices)
    end

    def visit_greaterThanEqual(node)
        left = node.left.visit(self)
        right = node.right.visit(self)
        
        return left if is_null?(left)
        return right if is_null?(right)
        
        assert_numeric(left)
        assert_numeric(right)

        raw_result = left.value >= right.value
        return BooleanPrimitive.new(raw_result, node.indices)
    end

    # Casting
    def visit_float_to_int(node)
        ftoi_node = node.operand.visit(self)
        return ftoi_node if is_null?(ftoi_node)
        assert_numeric(ftoi_node)

        return IntegerPrimitive.new(ftoi_node.value.to_i, node.indices)
    end

    def visit_int_to_float(node)
        itof_node = node.operand.visit(self)
        return itof_node if is_null?(itof_node)
        assert_numeric(itof_node)

        return FloatPrimitive.new(itof_node.value.to_f, node.indices)
    end

    # rValues
    def visit_variable(node)
        var_name = node.name
        value = @runtime.lookup(var_name)

        return value        
    end

    # Print
    def visit_print(node)
        # Evaluate the expression inside print
        print_statement = node.operand.visit(self)
  
        # Get the raw Ruby value
        raw_val = print_statement.value.to_s
  
        # Push it into the VariableTracker's @output array
        @runtime.log_print(raw_val)

        # Return the primitive so the "Act" column shows "eer" too
        return print_statement
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
        last_result = NullPrimitive.new(node.indices)

        node.statements.each do |statement|
            last_result = statement.visit(self)
        end

        return last_result
    end

    # Conditional
    def visit_conditional(node)
        condition = node.condition.visit(self)
        assert_boolean(condition)

        if condition.value
            return node.then_block.visit(self)
        elsif node.else_block
            return node.else_block.visit(self)
        else
            NullPrimitive.new(node.indices)
        end
    end

    #Loops
    MAX_ITERATIONS = 1000000
    def visit_while(node)
        result = NullPrimitive.new(node.indices)
        iteration = 0
        
        loop do
            condition = node.condition.visit(self)
            assert_boolean(condition)
            break unless condition.value

            iteration += 1
            if iteration > MAX_ITERATIONS
                raise "Runtime Error: Infinite loop."  
            end
            result = node.body.visit(self)
        end
        result
    end

    def visit_foreach(node)
        start_val = node.start_expr.visit(self)
        end_val = node.end_expr.visit(self)

        assert_integer(start_val)
        assert_integer(end_val)

        result = NullPrimitive.new(node.indices)
        (start_val.value..end_val.value).each do |i|
            @runtime.assign(node.variable, IntegerPrimitive.new(i, node.indices)) 
            result = node.body.visit(self) 
        end
        result
    end

    # Functions
    # no execution yet, just dtoring function def in runtime
    def visit_function_def(node)
        @runtime.define_function(node.name, node)
        NullPrimitive.new(node.indices)  
    end

    def visit_function_call(node)
        func_def = @runtime.lookup_function(node.name)
        raise "Undefined Function '#{node.name}'" unless func_def
        
        args = node.args.map { |arg| arg.visit(self) }
        if args.length != func_def.params.length
            raise "Argument Error: '#{node.name}'"  
        end

        # builds callees variable bindings
        child_vars = {}
        func_def.params.each_with_index do |param, i|
            child_vars[param] = args[i]  
        end

        child_runtime = VariableTracker.new(child_vars, @runtime.functions)
        child_evaluator = Evaluator.new(child_runtime)

        begin
            # If the function body just finishes naturally, return its last value
            return func_def.body.visit(child_evaluator)
        rescue ReturnException => e
            # This is the "teleportation" – catch the value thrown by 'return'
            return e.value
        end
        
        NullPrimitive.new(node.indices)
    end

    def visit_return(node)
        val = node.expression.visit(self)
        raise ReturnException.new(val)
    end
end
