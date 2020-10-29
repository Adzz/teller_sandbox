defmodule Teller.Account do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:currency_code, :string)
    field(:enrollment_id, :string)
    field(:id, :string)
    embeds_one(:institution, Teller.Institution)
    embeds_one(:links, AccountLink)
    field(:name, :string)
    field(:type, :string)
    field(:subtype, :string)
  end
end
