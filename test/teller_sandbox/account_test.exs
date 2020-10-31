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
  end
end
