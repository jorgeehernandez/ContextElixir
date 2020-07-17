defmodule ContextElixir.ContextMonitoringImplOne do
  @moduledoc false

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(_opts) do
    monitor()
    {:ok, %{}}
  end

  def monitor do
    # Execute loop every 1 second
    Process.send_after(self(), :monitor, 1 * 1000)
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end


  def handle_info(:monitor, state) do
    IO.puts "executing monitor"

    #monitoring rules
    random_number = :rand.uniform(20)
    if random_number > 10 do
      ContextElixir.ContextSupervisor.activate_on_child({[ContextElixir.VariationOne, ContextElixir.VariationTwo], "ContextAgent"})
    else
      ContextElixir.ContextSupervisor.activate_on_child({[ContextElixir.VariationTwo], "ContextAgent"})
    end

    #end of monitoring rules

    monitor()
    {:noreply, state}
  end


end