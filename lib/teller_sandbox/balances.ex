defmodule Teller.Balances do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:available, :decimal)
    field(:ledger, :decimal)
  end
end
