class Lexer
    def initialize(source)
        @source = source
        @cursor = 0
    end

    def tokenize
        tokens = []

        while @cursor < @source.length
            char = peek

            case char
            when /[ \t\r\n]/
                advance # Skip whitespace
            when /[0-9]/
                tokens << lex_number
            when /[a-zA-Z_]/
                tokens << lex_identifier
            when '"'
                tokens << lex_string
            else
                tokens << lex_operator
            end
        end
        tokens
    end

    private

    # Helper: Look at current char without moving
  def peek(offset = 0)
    @source[@cursor + offset]
  end

  # Helper: Grab char and move forward
  def advance
    char = peek
    @cursor += 1
    char
  end

  # 1. Numbers (Integers & Floats)
  def lex_number
    start = @cursor
    text = ""
    while @cursor < @source.length && (peek =~ /[0-9.]/)
      text += advance
    end
    
    type = text.include?(".") ? :FLOAT_LITERAL : :INTEGER_LITERAL
    Token.new(type, text, start, @cursor - 1)
  end

  # 2. Identifiers (Variables & Keywords like "print")
  def lex_identifier
    start = @cursor
    text = ""
    while @cursor < @source.length && (peek =~ /[a-zA-Z0-9_]/)
      text += advance
    end

    # Check if this "name" is actually a keyword
    type = (text == "print") ? :PRINT : :VARIABLE
    Token.new(type, text, start, @cursor - 1)
  end

  # 3. Strings
  def lex_string
    start = @cursor
    advance # consume the opening "
    text = ""
    while @cursor < @source.length && peek != '"'
      text += advance
    end
    advance # consume the closing "
    Token.new(:STRING_LITERAL, text, start, @cursor - 1)
  end

  # 4. Operators (The "Lookahead" logic)
  def lex_operator
    start = @cursor
    char = advance
    
    # Check for 2-character operators
    two_char_ops = ["==", "!=", "<=", ">=", "&&", "||", "**", "<<", ">>"]
    combined = char + (peek || "")

    if two_char_ops.include?(combined)
      advance # consume the 2nd char
      Token.new(get_type(combined), combined, start, @cursor - 1)
    else
      Token.new(get_type(char), char, start, @cursor - 1)
    end
  end

  def get_type(op)
    types = {
      "+" => :PLUS, "-" => :MINUS, "*" => :MULTIPLY, "/" => :DIVIDE,
      "%" => :MODULO, "=" => :ASSIGN, "==" => :EQUAL, "!=" => :NOT_EQUAL,
      "<" => :LT, ">" => :GT, "<=" => :LTE, ">=" => :GTE,
      "&&" => :AND, "||" => :OR, "!" => :NOT, "**" => :POWER,
      "(" => :LPAREN, ")" => :RPAREN, "&" => :BIT_AND, "|" => :BIT_OR,
      "^" => :BIT_XOR, "~" => :BIT_NOT, "<<" => :LSHIFT, ">>" => :RSHIFT
    }
    types[op] || :UNKNOWN
  end

end