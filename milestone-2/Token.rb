class Token
    attr_reader :type, :text, :start_index, :end_index

    def initialize(type, text, start_index, end_index)
        @type = type
        @text = text
        @start_index = start_index
        @end_index = end_index
    end

    def to_string
        "Token(#{@type}, '#{@text}', #{@start_index}..#{end_index})"
    end
end