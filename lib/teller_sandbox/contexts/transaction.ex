defmodule Teller.Contexts.Transaction do
  alias Teller.Contexts.Account
  @min_transaction_cost_in_pennies 133

  @doc """
  Generates 90 transactions in a consistent way.
  """
  def generate_from_account(account = %Teller.Account{}) do
    hash = Murmur.hash_x86_32(account)
    today = date().utc_today()
    the_past = Date.add(today, -89)

    # The total spend of all transactions needs to drop us at the available balance of the account.
    # Meaning we have to work backwards. We do that by generating a total spend for the last
    # 90 transactions, then picking varying but repeatable transaction amount for each transaction,
    # such that the total of all transactions minus the starting balance equals the account balance

    balance_in_pennies =
      account.balances.available |> Decimal.mult(Decimal.new("100")) |> Decimal.to_integer()

    # Pick a "random" number between 0 and the current account balance
    transaction_total_spend =
      Integer.mod(Murmur.hash_x86_32(account.balances.available), balance_in_pennies)
      |> Decimal.new()
      |> Decimal.div(Decimal.new("100"))

    {_, transactions} =
      Date.range(the_past, today)
      |> Enum.reduce({transaction_total_spend, []}, fn date, {balance, transactions} ->
        transactions_left = 90 - length(transactions)
        amount = amount(balance, transactions_left)
        running_balance = Decimal.sub(balance, amount)
        # This makes the id random, but it needs to be predictable.
        id = "test_txn_" <> Base.encode32("#{Murmur.hash_x86_32(date)}")

        transaction = %Teller.Transaction{
          id: id,
          type: type(),
          account_id: account.id,
          links: %Teller.TransactionLink{
            self: "http://localhost/accounts/#{account.id}/transactions/#{id}",
            account: "http://localhost/accounts/#{account.id}"
          },
          date: date,
          running_balance: Decimal.add(balance, account.balances.available),
          amount: Decimal.negate(amount),
          description: Enum.at(merchants(), Integer.mod(hash, length(merchants())))
        }

        {running_balance, [transaction | transactions]}
      end)

    transactions
  end

  @doc """
  Returns the transaction with the given id or nil if it can't be found.
  """
  def get_by_id(token, account_id, transaction_id) do
    with account = %{} <- Account.get_by_id(token, account_id),
         transactions = [_ | _] <- generate_from_account(account) do
      Enum.find(transactions, &(&1.id == transaction_id))
    end
  end

  defp amount(balance, 1), do: balance

  defp amount(balance, transactions_left) do
    hundred = Decimal.new("100")
    balance_in_pennies = balance |> Decimal.mult(Decimal.new("100")) |> Decimal.to_integer()
    # We convert to pennies to make the range a little easier.
    max_transaction_cost_in_pennies =
      (balance_in_pennies - transactions_left * @min_transaction_cost_in_pennies) /
        transactions_left

    Murmur.hash_x86_32(balance_in_pennies)
    |> Integer.mod(round(max_transaction_cost_in_pennies))
    |> Decimal.div(hundred)
  end

  defp type(), do: "card_payment"

  defp merchants() do
    [
      "Uber",
      "Uber Eats",
      "Lyft",
      "Five Guys",
      "In-N-Out Burger",
      "Chick-Fil-A",
      "AMC Metreon",
      "Apple",
      "Amazon",
      "Walmart",
      "Target",
      "Hotel Tonight",
      "Misson Ceviche",
      "The Creamery",
      "Caltrain",
      "Wingstop",
      "Slim Chickens",
      "CVS",
      "Duane Reade",
      "Walgreens",
      "Rooster & Rice",
      "McDonald's",
      "Burger King",
      "KFC",
      "Popeye's",
      "Shake Shack",
      "Lowe's",
      "The Home Depot",
      "Costco",
      "Kroger",
      "iTunes",
      "Spotify",
      "Best Buy",
      "TJ Maxx",
      "Aldi",
      "Dollar General",
      "Macy's",
      "H.E. Butt",
      "Dollar Tree",
      "Verizon Wireless",
      "Sprint PCS",
      "T-Mobile",
      "Kohl's",
      "Starbucks",
      "7-Eleven",
      "AT&T Wireless",
      "Rite Aid",
      "Nordstrom",
      "Ross",
      "Gap",
      "Bed, Bath & Beyond",
      "J.C. Penney",
      "Subway",
      "O'Reilly",
      "Wendy's",
      "Dunkin' Donuts",
      "Petsmart",
      "Dick's Sporting Goods",
      "Sears",
      "Staples",
      "Domino's Pizza",
      "Pizza Hut",
      "Papa John's",
      "IKEA",
      "Office Depot",
      "Foot Locker",
      "Lids",
      "GameStop",
      "Sephora",
      "MAC",
      "Panera",
      "Williams-Sonoma",
      "Saks Fifth Avenue",
      "Chipotle Mexican Grill",
      "Exxon Mobil",
      "Neiman Marcus",
      "Jack In The Box",
      "Sonic",
      "Shell"
    ]
  end

  defp date(), do: Application.fetch_env!(:teller_sandbox, :date_module)
end
