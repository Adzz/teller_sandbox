defmodule Teller.Dashboard do
  @behaviour TellerSandbox.DashboardBehaviour
  @moduledoc """
  This is a simple module to keep a count of the number of requests made to the API.
  It could be extended easily enough to have a break down per token, but for now we
  just keep counts for each endpoint.
  """
  use Agent
  @endpoints [:accounts, :account, :transactions, :transaction]

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  @doc """
  Returns the state of the Dashboard.
  """
  def metrics do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  Increments the counter for a given endpoint.
  """
  @impl true
  def increment_endpoint_count(endpoint) when endpoint in @endpoints do
    Agent.update(__MODULE__, fn state ->
      Map.merge(state, %{endpoint => Map.get(state, endpoint, 0) + 1})
    end)
  end
end
