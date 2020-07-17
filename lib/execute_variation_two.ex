defmodule ContextElixir.ExecuteVariationTwo do
  @moduledoc false
  require ContextElixir.ContextAgentImpl
  def execute() do
    IO.puts("Executing variation Two")
    #Read Measurements
    {:temp, value} = ContextElixir.ContextAgentImpl.read_temperature()
    IO.inspect  {:temp, value}
    #Analize Measurement
    case ContextElixir.ContextAgentImpl.analyse_temperature(value) do
      {:noAlarm, _} -> IO.puts "No alarm is required"
      {:alarm, value} -> ContextElixir.ContextAgentImpl.send_alarm(value)
    end
    IO.puts "End of loop"
  end
end
