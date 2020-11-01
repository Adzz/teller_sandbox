defmodule Teller.RoutingNumbers do
  use Teller.TellerSchema

  embedded_schema do
    field(:ach, :integer)
    field(:wire, :integer)
  end
end
