defmodule ContextElixir.VariationTwo do
  @moduledoc false
  require  ContextElixir.ContextAgentImpl
  def log(msg) do
    IO.puts("print from behaviour(variation) two")
    IO.inspect(msg)
#    ContextElixir.ContextAgentImpl.proceed()
  end
  def custom_function(arg1) do
    IO.puts("custom function from behaviour(variation) two")
    IO.inspect(arg1)
  end
end
