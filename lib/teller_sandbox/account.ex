defmodule Teller.Account do
  use Teller.TellerSchema

  embedded_schema do
    field(:account_number, :integer)
    embeds_one(:balances, Teller.Balances)
    field(:currency_code, :string)
    field(:enrollment_id, :string)
    field(:id, :string)
    embeds_one(:institution, Teller.Institution)
    embeds_one(:links, Teller.AccountLink)
    field(:name, :string)
    embeds_one(:routing_numbers, Teller.RoutingNumbers)
  end
end
