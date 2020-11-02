defmodule TellerSandboxWeb.DashboardLive do
  use TellerSandboxWeb, :live_view

  @moduledoc """
  A simple liveview to show the count of times each endpoint has been requested. This is
  inherently stateful for obvious reasons. I have opted to just poll for updates, so we
  refresh every N milliseconds.

  You could instead use Phoenix PubSub, and publish a message each time he state increases.
  """

  @refresh_rate 5000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @refresh_rate)
    {:ok, assign(socket, account: 0, accounts: 0, transaction: 0, transactions: 0)}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, @refresh_rate)
    {:noreply, assign(socket, Teller.Dashboard.metrics())}
  end
end
