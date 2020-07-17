defmodule ContextElixir.ContextSupervisorModel do
  @moduledoc false

  @callback  activate_on_child([]) :: {:ok} | {:error}
  @callback  monitoring_environment() :: {:ok} | {:error}

end
