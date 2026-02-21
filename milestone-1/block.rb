class Block < AstNode
    attr_reader :statements
    def initialize(statements)
        @statements = statements
    end
    def visit(visitor)
        visitor.visit_block(self)
    end

    def precedence
    Translator::PRECEDENCE[:block]
  end
end