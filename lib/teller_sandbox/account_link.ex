defmodule Teller.AccountLink do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:balances, :string)
    field(:details, :string)
    field(:self, :string)
    field(:transactions, :string)
  end
end
