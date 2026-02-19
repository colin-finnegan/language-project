class Variable
    attr_reader :operand
    def initialize(name)
        @name = name
    end
    def visit(visitor)
        visitor.visit_variable(self)
    end
end