
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
    if has(type)
      return advance
    else
      raise "#{message} at index #{peek&.start_index}"
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

  # statement = print | assignment | expression
  def parse_statement
    if has(:PRINT)
      parse_print
    else
      parse_expression
    end
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

  # relational = relational "==" additive
  #            | relational "!=" additive
  #            | relational "<"  additive
  #            | relational ">"  additive
  #            | relational "<=" additive
  #            | relational ">=" additive
  #            | additive
  def parse_relational
    left = parse_additive
    if has(:EQUAL) || has(:NOT_EQUAL) || has(:LT) || has(:GT) || has(:LTE) || has(:GTE)
      token = advance
      right = parse_additive
      
      case token.type
      when :EQUAL then left = Equals.new(left, right, [left.start_index, right.end_index])
      when :NOT_EQUAL then left = NotEquals.new(left, right, [left.start_index, right.end_index])
      when :LT then left = LessThan.new(left, right, [left.start_index, right.end_index])
      when :GT then left = GreaterThan.new(left, right, [left.start_index, right.end_index])
      when :LTE then left = LessThanEqual.new(left, right, [left.start_index, right.end_index])
      when :GTE then left = GreaterThanEqual.new(left, right, [left.start_index, right.end_index])
      end
    end
    left
  end

  # additive = additive "+" multiplicative| additive "-" multiplicative | multiplicative
  def parse_additive
    left = parse_multiplicative
    while has(:PLUS) || has(:MINUS)
      token = advance
      right = parse_multiplicative
      if token.type == :PLUS; left = Add.new(left, right, [left.start_index, right.end_index])
      elsif token.type == :MINUS; left = Subtract.new(left, right, [left.start_index, right.end_index]) end
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
    while has(:MULTIPLY) || has(:DIVIDE) || has(:MODULO) || has(:BIT_AND) || 
      has(:BIT_OR) || has(:BIT_XOR) || has(:LSHIFT) || has(:RSHIFT)

      token = advance
      right = parse_power

      case token.type # try to change... lots of LOC?? IDKKKKKK
      when :MULTIPLY then left = Multiply.new(left, right, [left.start_index, right.end_index])
      when :DIVIDE then left = Divide.new(left, right, [left.start_index, right.end_index])
      when :MODULO then left = Modulo.new(left, right, [left.start_index, right.end_index])
      when :BIT_AND then left = BitwiseAnd.new(left, right, [left.start_index, right.end_index])
      when :BIT_OR then left = BitwiseOr.new(left, right, [left.start_index, right.end_index])
      when :BIT_XOR then left = BitwiseXor.new(left, right, [left.start_index, right.end_index])
      when :LSHIFT then left = BitwiseLeftShift.new(left, right, [left.start_index, right.end_index])
      when :RSHIFT then left = BitwiseRightShift.new(left, right, [left.start_index, right.end_index])
      end
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
    if has(:NOT)
      token = advance
      operand = parse_unary # !!!true
      return Not.new(operand, [token.start_index, operand.end_index])
    elsif has(:MINUS)
      token = advance
      operand = parse_unary
      return UnaryNegation.new(operand, [token.start_index, operand.end_index])
    elsif has(:BIT_NOT)
      token = advance
      operand = parse_unary
      return BitwiseNot.new(operand, [token.start_index, operand.end_index])
    elsif has(:VARIABLE) && (peek.text == "floattoint" || peek.text == "inttofloat")
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

    if name_token.text == "floattoint"; FloatToInt.new(exp, [name_token.start_index, end_token.end_index]) end
    if name_token.text == "inttofloat"; IntToFloat.new(exp, [name_token.start_index, end_token.end_index]) end
  end

  # primary = INTEGER | FLOAT | STRING | BOOLEAN | VARIABLE | "(" expression ")"
  def parse_primary
    token = advance
    case token.type
    when :INTEGER_LITERAL then IntegerPrimitive.new(token.text.to_i, [token.start_index, token.end_index])
    when :FLOAT_LITERAL then FloatPrimitive.new(token.text.to_f, [token.start_index, token.end_index])
    when :STRING_LITERAL then StringPrimitive.new(token.text, [token.start_index, token.end_index])
    when :BOOLEAN then BooleanPrimitive.new(token.text == "true", [token.start_index, token.end_index])
    when :VARIABLE then Variable.new(token.text, [token.start_index, token.end_index])
    when :NULL then NullPrimitive.new([token.start_index, token.end_index])
    when :LPAREN
      exp = parse_expression
      consume(:RPAREN, "Expected ')'")
      exp
    else raise "Unexpected token #{token.type} at #{token.start_index}"
    end
  end

end