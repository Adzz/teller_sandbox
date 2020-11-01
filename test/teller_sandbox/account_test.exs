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
                 balances: nil,
                 details: nil,
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
      [account_1, account_2] = Teller.Account.from_token("multiple_1234567865")

      assert %Teller.Account{
               account_number: 363_716_149,
               balances: %Teller.Balances{available: 10, ledger: 10},
               currency_code: "USD",
               enrollment_id: "test_MzYzNzE2MTQ5",
               id: "test_acc_GM3DGNZRGYYTIOI=",
               institution: %Teller.Institution{id: "citi", name: "Citi"},
               links: %Teller.AccountLink{
                 balances: nil,
                 details: nil,
                 self: "http://localhost/accounts/test_acc_GM3DGNZRGYYTIOI=",
                 transactions: "http://localhost/accounts/test_acc_GM3DGNZRGYYTIOI=/transactions"
               },
               name: "Barack Obama",
               routing_numbers: %Teller.RoutingNumbers{ach: 4_037_215_853, wire: 2_438_602_713}
             } = account_1

      assert %Teller.Account{
               account_number: 1_234_567_865,
               balances: %Teller.Balances{available: 10, ledger: 10},
               currency_code: "USD",
               enrollment_id: "test_MTIzNDU2Nzg2NQ==",
               id: "test_acc_GEZDGNBVGY3TQNRV",
               institution: %Teller.Institution{id: "capital_one", name: "Capital One"},
               links: %Teller.AccountLink{
                 balances: nil,
                 details: nil,
                 self: "http://localhost/accounts/test_acc_GEZDGNBVGY3TQNRV",
                 transactions: "http://localhost/accounts/test_acc_GEZDGNBVGY3TQNRV/transactions"
               },
               name: "Donald Trump",
               routing_numbers: %Teller.RoutingNumbers{ach: 55_443_128, wire: 1_491_488_761}
             } = account_2
    end

    test "repeating a multiple token returns the same results" do
      [account_1, account_2] = Teller.Account.from_token("multiple_1234567865")
      [account_a, account_b] = Teller.Account.from_token("multiple_1234567865")

      assert account_1 == account_a
      assert account_2 == account_b
    end
  end
end
