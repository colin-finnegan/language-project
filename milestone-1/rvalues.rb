class Variable
    attr_reader :name, :indices
    def initialize(name, indices)
        @name = name
        @indices = indices 
    end

    def start_index
        @indices[0]
    end

    def end_index
        @indices[1]
    end
    def visit(visitor)
        visitor.visit_variable(self)
    end

    def precedence
        Translator::PRECEDENCE[:rvalue]
    end
end