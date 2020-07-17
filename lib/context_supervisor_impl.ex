defmodule ContextElixir.ContextSupervisor do
  @moduledoc false
  @behaviour ContextElixir.ContextSupervisorModel

  use Supervisor
  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(arg) do
    children = [
      worker(ContextElixir.ContextAgentImpl, [arg], restart: :permanent, id: "ContextAgent"),
      worker(ContextElixir.ContextLoopImpl, [arg], restart: :permanent, id: "ContextLoop"),
      worker(ContextElixir.ContextMonitoringImplOne, [arg], restart: :permanent, id: "ContextMonitoringOne")
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

  #  context elixir framework

  @impl ContextElixir.ContextSupervisorModel
  def monitoring_environment() do

  end

  @impl ContextElixir.ContextSupervisorModel
  def activate_on_child({variations, module_to_activate}) do
    children = Supervisor.which_children(__MODULE__)
    Enum.each(
      children,
      fn {name, pid, worker, modules} ->
        if name == module_to_activate do
          GenServer.cast(pid, {:set, variations})
        end
      end
    )
  end
end