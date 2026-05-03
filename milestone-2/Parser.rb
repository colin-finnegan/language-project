
class Parser
  def initialize(tokens)
    @tokens = tokens
    @cursor = 0 
    # tracks current position within list
  end
  
  # the entry point to parse the complete list
  # returns root node of the AST
  def parse
    node = parse_block
    if !at_end?
      token = peek
      # after valid grammar tokens done, but list isn't empty: raise an error
      raise "Unexpected token '#{token.text} at index #{token.start_index}"
    end
    node
  end

  # checks if cursor is at the end
  def at_end?
    @cursor >= @tokens.length
  end
  # sees if current token matches a type
  # does NOT move cursor
  def has(type)
    if at_end?; return false end
    peek.type == type
  end

  # moves cursor forward
  def advance
    token = @tokens[@cursor]
    @cursor += 1
    token
  end

  def consume(type, message)
    if at_end?
    # Report error at the end of the last known token
    last_pos = @tokens.last ? @tokens.last.end_index : 0
    raise "#{message} (Reached end of input at index #{last_pos})"
    end
    
    if has(type)
      advance
    else
      raise "#{message} at index #{peek.start_index}"
    end
  end


  # Looks at next token of current cursor
  # offset : from certain position
  def peek(offset = 0)
    @tokens[@cursor + offset]
  end

  # --- The grammar non- terminals ---
  
  #block = statement*
  def parse_block
    statements = []
    if !at_end?
      start_index = peek.start_index
    end

    while !at_end?
      statements.push(parse_statement)
    end
    end_index = statements.last ? statements.last.end_index : 0 # t then f
    Block.new(statements, [start_index || 0, end_index])
  end

  def parse_expression
    parse_assignment
  end

  # statement = print | assignment | expression | loops | functions | return
  def parse_statement
    if has(:PRINT)
      parse_print
    elsif has(:WHILE)
      parse_while
    elsif has(:FOR)
      parse_foreach
    elsif has(:IF)
      parse_conditional
    elsif has(:FUNCTION)
      parse_function_def
    elsif has(:RETURN)
      parse_return
    else
      parse_expression
    end
  end

  def parse_conditional
    if_token = advance
    condition = parse_expression
    then_block = parse_block
    else_block = nil
    if has(:ELSE)
      advance
      else_block = parse_block
    end
    
    end_token = consume(:END, "Expected 'end' to close 'if'")
    Conditional.new(condition, then_block, else_block, [if_token.start_index, end_token.end_index])
  end

  def parse_while
    while_token = advance
    condition = parse_expression
    body = parse_block
    end_token = consume(:END, "Expected 'end' to close 'while'")
    WhileLoop.new(condition, body, [while_token.start_index, end_token.end_index])
  end

  def parse_foreach
    for_token = advance
    var_token = consume(:VARIABLE, "Expected variable name after 'for'")
    consume(:IN, "Expected 'in' after loop variable")
    consume(:LBRACKET, "Expected '[' after 'in'")
    start_expr = parse_expression
    consume(:COMMA, "Expected ',' between rang bounds")
    end_expr = parse_expression
    consume(:RBRACKET, "Expected ']' after range end")
    body = parse_block
    end_token = consume(:END, "Expected 'end' to close 'for")
    ForEach.new(var_token.text, start_expr, end_expr, body, [for_token.start_index, end_token.end_index])
  end

  def parse_function_def
    func_token = advance
    name_token = consume(:VARIABLE, "Expected function name after 'function'")
    consume(:LPAREN, "Expected '(' after function name")

    params = []
    unless has(:RPAREN)
      params << consume(:VARIABLE, "Expected parameter name").text
      while has(:COMMA)
        advance
        params << consume(:VARIABLE, "Expected parameter name").text
      end
    end

    consume(:RPAREN, "Expected ')' after parameter list")
    body = parse_block
    end_token = consume(:END, "Expected 'end' to close function body")
    FunctionDef.new(name_token.text, params, body, [func_token.start_index, end_token.end_index])
  end

  def parse_function_call
    name_token = advance
    consume(:LPAREN, "Expected '(' after function name '#{name_token.text}'")
    args = []
    unless has(:RPAREN)
      args << parse_expression
      while has(:COMMA)
        advance
        args << parse_expression
      end
    end

    end_token = consume(:RPAREN, "Expected ')' after argument list")
    FunctionCall.new(name_token.text, args, [name_token.start_index, end_token.end_index])
  end

  def parse_return
    return_token = advance
    exp = parse_expression
    Return.new(exp, [return_token.start_index, exp.end_index])
  end
  # print = "print" expression
  def parse_print
    token = advance
    exp = parse_expression
    Print.new(exp, [token.start_index, exp.end_index])
  end

  # assignment = VARIABLE "=" assignment | logicalor
  def parse_assignment
    if has(:VARIABLE)
      next_token = peek(1)

      if next_token && next_token.type == :ASSIGN
        name_token = advance
        advance # eats the '='
        #recursive call for right associativity
        right = parse_assignment
        
        return Assignment.new(name_token.text, right, [name_token.start_index, right.end_index])
      end
    end
    parse_logicalor
  end

  # logicalor = logicalor "||" logicaland | logicaland
  def parse_logicalor
    left = parse_logicaland
    while has(:OR)
      advance # eats ||
      right = parse_logicaland
      left = Or.new(left, right, [left.start_index, right.end_index])
    end
    left
  end

  # logicaland = logicaland "&&" relational | relational
  def parse_logicaland
    left = parse_relational
    while has(:AND)
      advance
      right = parse_relational
      left = And.new(left, right, [left.start_index, right.end_index])
    end
    left
  end

  # Binary Mapping (used in relational, additive, multiplicative)
  BINARY_MAP = {
    EQUAL: Equals, NOT_EQUAL: NotEquals, LT: LessThan, 
    GT: GreaterThan, LTE: LessThanEqual, GTE: GreaterThanEqual,
    PLUS: Add, MINUS: Subtract,
    MULTIPLY: Multiply, DIVIDE: Divide, MODULO: Modulo,
    BIT_AND: BitwiseAnd, BIT_OR: BitwiseOr, BIT_XOR: BitwiseXor,
    LSHIFT: BitwiseLeftShift, RSHIFT: BitwiseRightShift
  }

  # Unary Mapping (used in parse_unary)
  UNARY_MAP = {
    NOT: Not, 
    MINUS: UnaryNegation, 
    BIT_NOT: BitwiseNot
  }

  # Literal Mapping (used in parse_primary)
  LITERAL_MAP = {
    INTEGER_LITERAL: IntegerPrimitive, FLOAT_LITERAL: FloatPrimitive,
    STRING_LITERAL: StringPrimitive, BOOLEAN: BooleanPrimitive,
    VARIABLE: Variable, NULL: NullPrimitive
  }

  # relational = relational "==" additive
  #            | relational "!=" additive
  #            | relational "<"  additive
  #            | relational ">"  additive
  #            | relational "<=" additive
  #            | relational ">=" additive
  #            | additive
  def parse_relational
    left = parse_additive
    #(klass = NODE_MAP[peek&.type]) && (has(:EQUAL) || has(:NOT_EQUAL) || has(:LT) || has(:GT) || has(:LTE) || has(:GTE))
    if (klass = BINARY_MAP[peek&.type]) && [:EQUAL, :NOT_EQUAL, :LT, :GT, :LTE, :GTE].include?(peek.type)
      token = advance
      right = parse_additive
      left = klass.new(left, right, [left.start_index, right.end_index])

    end
    left
  end

  # additive = additive "+" multiplicative| additive "-" multiplicative | multiplicative
  def parse_additive
    left = parse_multiplicative
    while (klass = BINARY_MAP[peek&.type]) && [:PLUS, :MINUS].include?(peek.type)
      token = advance
      right = parse_multiplicative
      left = klass.new(left, right, [left.start_index, right.end_index])
    end
    left
  end

  # multiplicative = multiplicative "*" power
  #                | multiplicative "/" power
  #                | multiplicative "%" power
  #                | multiplicative "&" power
  #                | multiplicative "|" power
  #                | multiplicative "^" power
  #                | multiplicative "<<" power
  #                | multiplicative ">>" power
  #                | power
  def parse_multiplicative
    left = parse_power
    while (klass = BINARY_MAP[peek&.type]) && [:MULTIPLY, :DIVIDE, :MODULO, :BIT_AND, :BIT_OR, :BIT_XOR, :LSHIFT, :RSHIFT].include?(peek.type)
      #has(:MULTIPLY) || has(:DIVIDE) || has(:MODULO) || has(:BIT_AND) || 
      #has(:BIT_OR) || has(:BIT_XOR) || has(:LSHIFT) || has(:RSHIFT)

      token = advance
      right = parse_power
      left = klass.new(left, right, [left.start_index, right.end_index])

    end
    left
  end

  # power = unary "**" power | unary
  def parse_power
    left = parse_unary
    while has(:POWER)
      advance
      right = parse_unary
      left = Exponent.new(left, right, [left.start_index, right.end_index])
    end
    left
  end

  # unary = "!" unary | "-" unary | "~" unary | casting | primary
  def parse_unary
    if (klass = UNARY_MAP[peek&.type]) && [:MINUS, :NOT, :BIT_NOT].include?(peek.type)
      token = advance
      operand = parse_unary # !!!true
      return klass.new(operand, [token.start_index, operand.end_index])
    elsif has(:VARIABLE) && ["floattoint", "inttofloat"].include?(peek.text)
      return parse_casting
    else
      parse_primary
    end
  end

  # casting = "floattoint" "(" expression ")" | "inttofloat" "(" expression ")"
  def parse_casting
    name_token = advance # "floattoint" or "inttofloat"
    consume(:LPAREN, "Expected '(' after casting operator")
    exp = parse_expression
    end_token = consume(:RPAREN, "Expected ')' after casting operator")

    if name_token.text == "floattoint"; FloatToInt.new(exp, [name_token.start_index, end_token.end_index])
    elsif name_token.text == "inttofloat"; IntToFloat.new(exp, [name_token.start_index, end_token.end_index]) end
  end

  # primary = INTEGER | FLOAT | STRING | BOOLEAN | VARIABLE | "(" expression ")"
  def parse_primary
    token = advance
    klass = LITERAL_MAP[token.type]

    if klass
      # Handle specific literal conversions
      case token.type
      when :INTEGER_LITERAL then klass.new(token.text.to_i, [token.start_index, token.end_index])
      when :FLOAT_LITERAL   then klass.new(token.text.to_f, [token.start_index, token.end_index])
      when :BOOLEAN         then klass.new(token.text == "true", [token.start_index, token.end_index])
      when :NULL            then klass.new([token.start_index, token.end_index])
      else                       klass.new(token.text, [token.start_index, token.end_index])
      end
    elsif token.type == :LPAREN
      exp = parse_expression
      consume(:RPAREN, "Expected ')'")
      exp
    else
      raise "Unexpected token #{token.type} at #{token.start_index}"
    end
  end

end