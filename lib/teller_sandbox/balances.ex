defmodule Teller.Balances do
  use Teller.TellerSchema

  embedded_schema do
    field(:available, :decimal)
    field(:ledger, :decimal)
  end
end
