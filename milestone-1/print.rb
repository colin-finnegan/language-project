class Print
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
    
    def visit(visitor)
        visitor.visit_print(self)
    end

    def precedence
        Translator::PRECEDENCE[:print]
    end
end