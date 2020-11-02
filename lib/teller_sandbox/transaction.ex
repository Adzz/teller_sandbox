defmodule Teller.Transaction do
  use Teller.TellerSchema

  embedded_schema do
    field(:account_id, :string)
    field(:amount, :decimal)
    field(:date, :date)
    field(:description, :string)
    field(:id, :string)
    embeds_one(:links, Teller.TransactionLink)
    # this is the balance BEFORE the transaction amount is applied.
    field(:running_balance, :decimal)
    field(:type, :string)
  end
end
