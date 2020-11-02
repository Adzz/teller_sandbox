defmodule TellerSandbox.DashboardBehaviour do
  @callback increment_endpoint_count(Atom.t()) :: map()
end
