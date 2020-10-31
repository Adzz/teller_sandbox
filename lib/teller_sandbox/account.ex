defmodule Teller.Account do
  use Ecto.Schema

  @primary_key false
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

  @doc """
  Generates one or more accounts based on the given token. The data generated is hashed off of the
  token and we use the murmur hash. This ensures that the we don't have to store any state in order
  to always get the same data returned for a given token.

  It does not guarantee that the each token returns unique data however. We can
  """
  def from_token("multiple_" <> token) do
    # index = Integer.mod(Murmur.hash_x86_32(token), 5)
  end

  def from_token(token) do
    token_hash = Murmur.hash_x86_32(token)
    id = "test_acc_" <> Base.encode32("#{token}")
    ach = Murmur.hash_x86_32(token_hash)

    %__MODULE__{
      # I guess this should be uniq per token. Though then again multiple per token.
      account_number: String.to_integer(token),
      currency_code: "USD",
      enrollment_id: "test_" <> Base.encode64("#{token}"),
      id: id,
      name: Enum.at(account_names(), Integer.mod(token_hash, length(account_names()))),
      balances: %Teller.Balances{available: 10, ledger: 10},
      institution: Teller.Institution.from_token_hash(token_hash),
      links: %Teller.AccountLink{
        self: "http://localhost/accounts/#{id}",
        transactions: "http://localhost/accounts/#{id}/transactions"
      },
      routing_numbers: %Teller.RoutingNumbers{
        ach: ach,
        wire: Murmur.hash_x86_32(ach)
      }
    }
  end

  defp account_names do
    [
      "Jimmy Carter",
      "Ronald Reagan",
      "George H. W. Bush",
      "Bill Clinton",
      "George W. Bush",
      "Barack Obama",
      "Donald Trump"
    ]
  end
end
