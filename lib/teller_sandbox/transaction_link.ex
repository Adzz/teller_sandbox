defmodule Teller.TransactionLink do
  use Teller.TellerSchema

  embedded_schema do
    field(:account, :string)
    field(:self, :string)
  end
end
