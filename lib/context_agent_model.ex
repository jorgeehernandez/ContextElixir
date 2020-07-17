defmodule ContextElixir.ContextAgentModel do
  @moduledoc false
  @callback  find_function([], :atom, []) :: {:ok} | {:error}
  @callback  execute_method(false, [], :atom, []) :: {:ok} | {:error}
  @callback  execute_method(true, [], :atom, []) :: {:ok} | {:error}
  @callback  execute_context_function(:atom, []) :: {:ok} | {:error}
end
