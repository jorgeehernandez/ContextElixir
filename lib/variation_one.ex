defmodule ContextElixir.VariationOne do
  @moduledoc false
  require  ContextElixir.ContextAgentImpl
  def log(msg) do
    IO.puts("print from behaviour(variation) one")
    IO.inspect(msg)
    ContextElixir.ContextAgentImpl.proceed()
  end

  def custom_function(arg1, arg2) do
    IO.puts("custom function from behaviour(variation) one")
    ContextElixir.ContextAgentImpl.proceed()
  end
end
