defmodule Test do


  defmacro proceed do
    quote do
      envmap =  __ENV__
      IO.inspect envmap
      Test.find_function(envmap.function |> elem(0), envmap.function |> elem(1), envmap.module )
    end
  end

  def find_function(function, args, module) do
    IO.inspect function
    IO.inspect args
    IO.inspect module
  end


  def run do
    require ContextElixir.VariationTwo
    require ContextElixir.VariationOne

    {:ok, pid} = ContextElixir.ContextAgentImpl.start_link([])
    ContextElixir.ContextAgentImpl.activate([ContextElixir.VariationOne, ContextElixir.VariationTwo])
    ContextElixir.ContextAgentImpl.message("message to be printed")

  end




#  VariationOne.execute_variation()

end

defmodule VariationOne do
  require Test

  def execute_variation(var1) do
    IO.inspect "doing some work"
    IO.inspect __ENV__
    Test.proceed
  end

end


