defmodule ContextElixir.ContextAgentImpl do
  @moduledoc false
  @behaviour ContextElixir.ContextAgentModel
  use GenServer

  # Application context
  #_________________________________________
  # Own implementations (default behaviour)
  #_________________________________________
  def log(msg) do
    IO.puts("print from default behaviour")
    IO.inspect(msg)
  end

  def get_temperature do
    IO.puts("default behaviour to get temp")
    #make the read and return the temp value
    {:temp, 50}
  end

  def check_temperature(value) do
    if value >= 40 do
      {:alarm, 40}
    else
      {:noAlarm, 0}
    end
  end

  def create_alarm(value) do
    IO.puts "default behaviour to create alarm"
    IO.puts value
    alarm = ""
    {:ok, alarm}
  end

  def create_temperature(value) do
    IO.puts("default behaviour to create temperature")
    IO.puts value
    temperature = ""
    {:ok, temperature}
  end
  #_________________________________________
  def read_temperature do
    GenServer.call(__MODULE__, :get_temperature)
  end

  def analyse_temperature(value) do
    GenServer.call(__MODULE__, {:check_temperature, value})
  end

  def send_alarm(value) do
    GenServer.call(__MODULE__, {:create_alarm, value})
  end

  def send_temperature(value) do
    GenServer.call(__MODULE__, {:create_temperature, value})
  end

  def message(message) do
    GenServer.cast(__MODULE__, {:log, message})
  end
  #_________________________________________

  #  Implements genserver
  def start_link(variations) do
    GenServer.start_link(__MODULE__, variations, name: __MODULE__)
  end

  @impl true
  def init(variations) do
    IO.puts "Init context Agent"
    {:ok, variations}
  end

  @impl true
  def handle_cast({:log, message}, variations) do
    IO.inspect variations
    find_function(variations, :log, [message])
    {:noreply, variations}
  end


  @impl true
  def handle_call(:get_temperature, _from, variations) do
    IO.inspect "try to find the get temperature function"
    value = find_function(variations, :get_temperature, [])
    {:reply, value, variations}
  end

  @impl true
  def handle_call({:check_temperature, value}, _from, variations) do
    IO.inspect "try to find the get check temperature function"
    IO.inspect value
    value = find_function(variations, :check_temperature, [value])
    {:reply, value, variations}
  end

  @impl true
  def handle_call({:create_alarm, value}, _from, variations) do
    IO.inspect "try to find the create alarm function"
    IO.inspect value
    value = find_function(variations, :create_alarm, [value])
    {:reply, value, variations}
  end

  @impl true
  def handle_call({:create_temperature, value}, _from, variations) do
    IO.inspect "try to find the create temperature function"
    IO.inspect value
    value = find_function(variations, :create_temperature, [value])
    {:reply, value, variations}
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

  @impl true
  def handle_cast({module, function, args}, variations) do
    IO.puts "proceed was called"
    IO.inspect module
    IO.inspect function
    IO.inspect args
    IO.inspect variations

    # delete de variation inside the variations list and call find_function again
    new_variations = Enum.filter(variations, fn variation -> variation != module end)
    find_function(new_variations, function, args)
    {:noreply, variations}
  end


  #  @impl true
  #  def handle_cast({:log, 1, ContextElixir.VariationTwo}, variations) do
  #    IO.inspect :log
  #    IO.inspect 1
  #    IO.inspect variations
  #    # delete de variation inside the variation and call find_function again
  #    #    # find_function(envmap.function |> elem(0), envmap.function |> elem(1), envmap.module)
  #    #    # find_function(variations, :log, [message])
  #    {:noreply, variations}
  #  end

  @impl true
  def handle_cast({function, args}, variations) do
    IO.inspect(variations)
    find_function(variations, function, args)
    {:noreply, variations}
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

  #  ContextElixirFramework
  @impl ContextElixir.ContextAgentModel
  def execute_context_function(function, arg) do
    GenServer.cast(__MODULE__, {function, arg})
  end

  @impl ContextElixir.ContextAgentModel
  def find_function([h | t], func, args) do
    IO.inspect "try to fun function with module :"
    IO.inspect h
    execute_method(Kernel.function_exported?(h, func, length(args)), [h | t], func, args)
  end

  @impl ContextElixir.ContextAgentModel
  def find_function([], func, args) do
    IO.puts "Function not found in any variation"
    IO.inspect {func, args}
    apply(__MODULE__, func, args)
  end

  @impl ContextElixir.ContextAgentModel
  def execute_method(true, [h | t], func, args) do
    IO.inspect("Function found in  module: ")
    IO.inspect(h)
    apply(h, func, args)
  end

  @impl ContextElixir.ContextAgentModel
  def execute_method(false, [h | t], func, args) do
    IO.inspect("no found in module : ")
    IO.inspect h
    find_function(t, func, args)
  end

  defmacro proceed do
    quote do
      env_map = __ENV__
      [current_module | _] = env_map.requires
      module_used = env_map.module
      function = env_map.function
                 |> elem(0)
      GenServer.cast(
        current_module,
        {module_used, function, binding()}
      )
    end
  end


end
