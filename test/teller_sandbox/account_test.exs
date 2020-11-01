defmodule Teller.AccountTest do
  use ExUnit.Case, async: true

  describe "from_token" do
    test "Returns an account for a given token" do
      assert %Teller.Account{
               account_number: 1_234_567_865,
               balances: %Teller.Balances{available: 10, ledger: 10},
               currency_code: "USD",
               enrollment_id: "test_MTIzNDU2Nzg2NQ==",
               id: "test_acc_GEZDGNBVGY3TQNRV",
               institution: %Teller.Institution{id: "capital_one", name: "Capital One"},
               links: %Teller.AccountLink{
                 self: "http://localhost/accounts/test_acc_GEZDGNBVGY3TQNRV",
                 transactions: "http://localhost/accounts/test_acc_GEZDGNBVGY3TQNRV/transactions"
               },
               name: "Donald Trump",
               routing_numbers: %Teller.RoutingNumbers{ach: 55_443_128, wire: 1_491_488_761}
             } = Teller.Account.from_token("1234567865")
    end

    test "the same token twice returns the same account" do
      token = "1234567865"
      account_1 = Teller.Account.from_token(token)
      account_2 = Teller.Account.from_token(token)

      assert account_1 == account_2
    end

    test "if the token is multiple we produce mutltiple accounts" do
      [account_1, account_2] = Teller.Account.from_token("multiple_112")

      assert %Teller.Account{
               account_number: 1_915_688_566,
               balances: %Teller.Balances{available: 10, ledger: 10},
               currency_code: "USD",
               enrollment_id: "test_MTkxNTY4ODU2Ng==",
               id: "test_acc_GE4TCNJWHA4DKNRW",
               institution: %Teller.Institution{id: "citi", name: "Citi"},
               links: %Teller.AccountLink{
                 self: "http://localhost/accounts/test_acc_GE4TCNJWHA4DKNRW",
                 transactions: "http://localhost/accounts/test_acc_GE4TCNJWHA4DKNRW/transactions"
               },
               name: "Bill Clinton",
               routing_numbers: %Teller.RoutingNumbers{ach: 1_030_839_378, wire: 2_488_324_299}
             } = account_1

      assert %Teller.Account{
               account_number: 112,
               balances: %Teller.Balances{available: 10, ledger: 10},
               currency_code: "USD",
               enrollment_id: "test_MTEy",
               id: "test_acc_GEYTE===",
               institution: %Teller.Institution{id: "bank_of_america", name: "Bank of America"},
               links: %Teller.AccountLink{
                 self: "http://localhost/accounts/test_acc_GEYTE===",
                 transactions: "http://localhost/accounts/test_acc_GEYTE===/transactions"
               },
               name: "Ronald Reagan",
               routing_numbers: %Teller.RoutingNumbers{ach: 1_832_435_966, wire: 3_155_155_154}
             } = account_2
    end

    test "repeating a multiple token returns the same results" do
      [account_1, account_2] = Teller.Account.from_token("multiple_112")
      [account_a, account_b] = Teller.Account.from_token("multiple_112")

      assert account_1 == account_a
      assert account_2 == account_b
    end

    test "we don't repeat institutions" do
      # We could / should use property based testing here to ensure we never repeat an Institution.
      # Essentially generate the accounts and check that there are no repeats.
      assert [one, two, three, four, five] = accounts = Teller.Account.from_token("multiple_1")
      institutions = Enum.map(accounts, & &1.institution.id)

      assert one.institution.id not in (institutions -- [one.institution.id])
      assert two.institution.id not in (institutions -- [two.institution.id])
      assert three.institution.id not in (institutions -- [three.institution.id])
      assert four.institution.id not in (institutions -- [four.institution.id])
      assert five.institution.id not in (institutions -- [five.institution.id])
    end
  end
end
