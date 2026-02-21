# two visitors.
# visitor #1 : translates tree to string representation of program in another language
# will result in source code of that language.
# second visit is in evaluate so pay no regard...

# String should show operations & operands in readable manner

# The translate will walk the tree and produce a string representation of that structure.

# recursively walks, builds strings, combines child results

class Translator
  PRECEDENCE = {
    integer:        1  ,
    float:          1  ,
    boolean:        1  ,
    string:         1  ,
    null:           1  ,
    int2Float:      2  ,
    float2Int:      2  ,
    logOR:          3  ,
    logAND:         4  ,
    logNOT:         5  ,
    bitOR:          6  ,
    bitXOR:         7  ,
    bitAND:         8  ,
    relEquals:      9  ,
    relNotEquals:   9  ,
    lessThan:       10 ,
    greaterThan:    10 ,
    lessEqual:      10 ,
    greaterEqual:   10 ,
    leftShift:      11 ,
    rightShift:     11 ,
    add:            12 ,
    subtract:       12 ,
    multiply:       13 ,
    divide:         13 ,
    modulo:         13 ,
    exponent:       14 ,
    unaryNegation:  15 ,
    assignment:     16 ,
    print:          17 ,
    block:          18 

  }

  # entry point
  def translate(node)
    node.visit(self)
  end

  def visit_add()
end