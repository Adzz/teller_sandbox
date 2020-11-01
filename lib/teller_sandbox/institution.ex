defmodule Teller.Institution do
  use Teller.TellerSchema

  embedded_schema do
    field(:id, :string)
    field(:name, :string)
  end
end
