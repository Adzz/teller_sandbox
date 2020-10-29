defmodule Teller.TransactionLink do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:account, :string)
    field(:self, :string)
  end
end
