defmodule Teller.Institution do
  use Teller.TellerSchema

  embedded_schema do
    field(:id, :string)
    field(:name, :string)
  end

  def from_token_hash(token_hash) do
    institution = Enum.at(institutions(), Integer.mod(token_hash, length(institutions())))
    %Teller.Institution{id: institution.id, name: institution.name}
  end

  def institutions() do
    [
      %{id: "chase", name: "Chase"},
      %{id: "bank_of_america", name: "Bank of America"},
      %{id: "wells_fargo", name: "Wells Fargo"},
      %{id: "citi", name: "Citi"},
      %{id: "capital_one", name: "Capital One"}
    ]
  end
end
