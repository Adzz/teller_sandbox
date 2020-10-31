defmodule Teller.RoutingNumbers do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:ach, :integer)
    field(:wire, :integer)
  end
end
