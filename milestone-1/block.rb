class Block
    attr_reader :statements, :indices
    def initialize(statements, indices)
        @statements = statements
        @indices = indices
    end

    def start_index
        @indices[0]
    end

    def end_index
        @indices[1]
    end
    def visit(visitor)
        visitor.visit_block(self)
    end

    def precedence
    Translator::PRECEDENCE[:block]
    end
end