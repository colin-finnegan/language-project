class Variable < AstNode
    attr_reader :name
    def initialize(name)
        @name = name
    end
    def visit(visitor)
        visitor.visit_variable(self)
    end

    def precedence
    Translator::PRECEDENCE[:rvalue]
  end
end