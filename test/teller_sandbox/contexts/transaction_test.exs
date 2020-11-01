defmodule Teller.Contexts.TransactionTest do
  use ExUnit.Case, async: true
  alias Teller.Contexts.{Account, Transaction}
  import Mox

  describe "generate_from_account" do
    test "we generate the same accounts when we generate the same account twice" do
      expect(DateMock, :utc_today, 2, fn -> ~D[2020-11-01] end)
      token = Account.from_token("1234567865")
      transactions = Transaction.generate_from_account(token)
      transactions_2 = Transaction.generate_from_account(token)
      assert transactions == transactions_2
    end

    test "each id is different" do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)
      token = Account.from_token("1234567865")
      transactions = Transaction.generate_from_account(token)
      uniq_ids = Enum.map(transactions, & &1.id) |> Enum.uniq()
      assert length(uniq_ids) == length(transactions)
    end

    test "earliest date is 90 days ago, we have a date for each day in between" do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)
      token = Account.from_token("1234567865")
      transactions = Transaction.generate_from_account(token)

      assert List.first(transactions).date == ~D[2020-11-01]
      last = List.last(transactions)
      assert last.date == Date.add(~D[2020-11-01], -89)

      uniq_dates = Enum.map(transactions, & &1.date) |> Enum.uniq()
      assert length(uniq_dates) == length(transactions)
    end
  end
end
