require_relative 'token'

class Lexer
    TWO_CHAR_TYPES = {
    "==" => :EQUAL,  "!=" => :NOT_EQUAL, "<=" => :LTE,   ">=" => :GTE,
    "&&" => :AND,    "||" => :OR,        "**" => :POWER, 
    "<<" => :LSHIFT, ">>" => :RSHIFT
    }

    ONE_CHAR_TYPES = {
    "+" => :PLUS,     "-" => :MINUS,    "*" => :MULTIPLY, "/" => :DIVIDE,
    "%" => :MODULO,   "=" => :ASSIGN,   "<" => :LT,       ">" => :GT,
    "!" => :NOT,      "(" => :LPAREN,   ")" => :RPAREN,   "&" => :BIT_AND,
    "|" => :BIT_OR,   "^" => :BIT_XOR,  "~" => :BIT_NO,
    "[" => :LBRACKET, "]" => :RBRACKET, "," => :COMMA
    }
    
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
            when /\/\//
                advance while @cursor < @source.length && peek != "\n"
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

    # Explicitly check for booleans and null
    type = case text
      when "print"         then :PRINT
      when "true", "false" then :BOOLEAN
      when "null"          then :NULL
      when "if"            then :IF
      when "else"          then :ELSE
      when "end"           then :END
      when "while"         then :WHILE
      when "for"           then :FOR
      when "in"            then :IN
      when "function"      then :FUNCTION
      when "return"        then :RETURN
      else                      :VARIABLE
      end

    Token.new(type, text, start, @cursor - 1)
  end

  # 3. Strings
  def lex_string
    start = @cursor
    advance
    text = ""
    while @cursor < @source.length && peek != '"'
      text += advance
    end
    advance
    Token.new(:STRING_LITERAL, text, start, @cursor - 1)
  end

  def lex_operator
    start = @cursor
    char = advance
  
    combined = char + (peek || "")

    if TWO_CHAR_TYPES.key?(combined)
      advance
      Token.new(TWO_CHAR_TYPES[combined], combined, start, @cursor - 1)

    elsif ONE_CHAR_TYPES.key?(char)
      Token.new(ONE_CHAR_TYPES[char], char, start, @cursor - 1)

    else
      Token.new(:UNKNOWN, char, start, @cursor - 1)
    end
  end
end