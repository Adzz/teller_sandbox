defmodule Teller.Transaction do
  use Teller.TellerSchema

  embedded_schema do
    field(:account_id, :string)
    field(:amount, :decimal)
    field(:date, :decimal)
    field(:description, :string)
    field(:status, :string)
    field(:id, :string)
    embeds_one(:link, Teller.TransactionLink)
    field(:running_balance, :decimal)
    field(:type, :string)
  end
end
