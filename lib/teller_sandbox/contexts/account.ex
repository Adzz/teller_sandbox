defmodule Teller.Contexts.Account do
  alias Teller.Contexts.Institution
  @link_prepend "http://localhost/accounts/"

  @doc """
  Generates one or more accounts based on the given token. The data generated is hashed off of the
  token and we use the murmur hash. This ensures that the we don't have to store any state in order
  to always get the same data returned for a given token.

  It does not guarantee that the each token returns unique data however, but it will be different
  enough in most cases to not matter.
  """
  def from_token("multiple_" <> token) do
    # The gotcha here is that we can't have more than one of the same account. So the two options
    # are 1. retry if we create an account we have alreayd created, or
    # 2. make it so that it can't create an account that exists already.
    # I have opted for the latter.

    # To do that we need to reduce over the data, so we can remove account names and institutions
    # as they are used. We also need to change the token slightly for each so we get different
    # results.

    # The max number of accounts is the number of possible institutions because we can't repeat them.
    institutions = Institution.institutions()
    number_of_accounts = Integer.mod(Murmur.hash_x86_32(token), length(institutions))
    initial_accumulator = {token, the_account_names(), institutions, []}

    {_, _, _, accounts} =
      0..number_of_accounts
      |> Enum.reduce(initial_accumulator, fn _, {token, account_names, institutions, acc} ->
        token_hash = Murmur.hash_x86_32(token)
        id = "test_acc_" <> Base.encode32("#{token}")
        ach = Murmur.hash_x86_32(token_hash)
        name = Enum.at(account_names, Integer.mod(token_hash, length(account_names)))
        institution = Enum.at(institutions, Integer.mod(token_hash, length(institutions)))
        balance = Decimal.new("10000")

        account = %Teller.Account{
          account_number: String.to_integer(token),
          currency_code: "USD",
          enrollment_id: "test_" <> Base.encode64("#{token}"),
          id: id,
          name: name,
          balances: %Teller.Balances{available: balance, ledger: balance},
          institution: %Teller.Institution{id: institution.id, name: institution.name},
          links: %Teller.AccountLink{
            self: @link_prepend <> "#{id}",
            transactions: @link_prepend <> "#{id}/transactions"
          },
          routing_numbers: %Teller.RoutingNumbers{
            ach: ach,
            wire: Murmur.hash_x86_32(ach)
          }
        }

        {"#{token_hash}", account_names -- [name], institutions -- [institution], [account | acc]}
      end)

    accounts
  end

  def from_token(token) do
    token_hash = Murmur.hash_x86_32(token)
    id = "test_acc_" <> Base.encode32("#{token}")
    ach = Murmur.hash_x86_32(token_hash)
    balance = Decimal.new("10000")

    %Teller.Account{
      account_number: String.to_integer(token),
      currency_code: "USD",
      enrollment_id: "test_" <> Base.encode64("#{token}"),
      id: id,
      name: Enum.at(the_account_names(), Integer.mod(token_hash, length(the_account_names()))),
      balances: %Teller.Balances{available: balance, ledger: balance},
      institution: Institution.from_token_hash(token_hash),
      links: %Teller.AccountLink{
        self: @link_prepend <> "#{id}",
        transactions: @link_prepend <> "#{id}/transactions"
      },
      routing_numbers: %Teller.RoutingNumbers{
        ach: ach,
        wire: Murmur.hash_x86_32(ach)
      }
    }
  end

  @doc "Returns the account with the given id if it exists for that token otherwise returns nil."
  def get_by_id(token = "multiple_" <> _, account_id) do
    Enum.find(from_token(token), &(&1.id == account_id))
  end

  def get_by_id(token, account_id) do
    account = %{id: id} = from_token(token)

    if account_id == id do
      account
    end
  end

  defp the_account_names do
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
