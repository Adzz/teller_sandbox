defmodule Teller.AccountLink do
  use Teller.TellerSchema

  embedded_schema do
    field(:self, :string)
    field(:transactions, :string)
  end
end
