class Runtime
  def initialize
    @variables = {}
  end

  def assign(name, value_node)
    @variables[name] = value_node
  end

  def lookup(name)
    @variables[name] || NullPrimitive.new
  end
end