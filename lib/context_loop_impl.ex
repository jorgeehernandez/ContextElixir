defmodule ContextElixir.ContextLoopImpl do
  @moduledoc false
  use GenServer

  def start_link(variations) do
    GenServer.start_link(__MODULE__, variations, name: __MODULE__)
  end

  def init(variations) do
    IO.puts "Init context loop"
    loop()
    {:ok, variations}
  end

  def handle_info(:loop, variations) do
    IO.puts "executing loop"
    IO.inspect variations
    Enum.each(variations, fn variation -> variation.execute()  end)
    loop()
    {:noreply, variations}
  end

  def loop do
    # Execute loop every 1 second
    Process.send_after(self(), :loop, 1 * 1000)
  end

  @impl true
  def handle_call(:get, _from, [variation | variations]) do
    {:reply, [variation | variations], [variation | variations]}
  end

  @impl true
  def handle_call(:get, _from, []) do
    {:reply, [], []}
  end


  @impl true
  def handle_cast({:set, new_variations}, variations) do
    IO.puts "New variations"
    IO.inspect new_variations
    {:noreply, new_variations}
  end


  def activate([h | t]) do
    IO.puts "activating new variations"
    GenServer.cast(__MODULE__, {:set, [h | t]})
  end


  def activate([]) do
    IO.puts "activating empty variations"
    GenServer.cast(__MODULE__, {:set, []})
  end

  def variations() do
    GenServer.call(__MODULE__, :get)
  end




end
