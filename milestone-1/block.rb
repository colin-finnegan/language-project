class Block
    attr_reader :statements
    def initialize(statements)
        @statements = statements
    end
    def visit(visitor)
        visitor.visit_block(self)
    end
end