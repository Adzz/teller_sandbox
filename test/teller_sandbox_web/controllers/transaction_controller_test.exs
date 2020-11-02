defmodule TellerSandboxWeb.TransactionControllerTest do
  use TellerSandboxWeb.ConnCase, async: true
  import Mox

  describe "all" do
    test "incorrect params is a 404", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_multiple_2:")}")
        |> get(Routes.transaction_path(conn, :all, "NOPE"), %{"also" => "NOPE"})

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "incorrect id is not found", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_multiple_2:")}")
        |> get(Routes.transaction_path(conn, :all, "NOPE"), %{"account_id" => "NOPE"})

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "We can query for all of the transactions for a given account", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)

      response =
        build_conn()
        |> put_req_header(
          "authorization",
          "Basic #{Base.url_encode64("test_multiple_1234567891:")}"
        )
        |> get(Routes.transaction_path(conn, :all, "test_acc_GEZDGNBVGY3TQOJR"), %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJR"
        })

      account =
        Teller.Contexts.Account.get_by_id("multiple_1234567891", "test_acc_GEZDGNBVGY3TQOJR")

      decoded = Jason.decode!(response.resp_body)
      assert length(decoded) == 90
      assert response.resp_body == File.read!("test/support/fixtures/transactions.json")

      total_transaction_spend =
        Enum.reduce(decoded, Decimal.new(0), fn transaction, acc ->
          Decimal.new(transaction["amount"])
          |> Decimal.add(acc)
        end)
        |> Decimal.mult(-1)

      starting_balance = Decimal.new(List.last(decoded)["running_balance"])
      total_after_spend = Decimal.sub(starting_balance, total_transaction_spend)

      assert Decimal.compare(total_after_spend, account.balances.available) == :eq
    end
  end

  describe "get" do
    test "incorrect params is a 404", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_multiple_2:")}")
        |> get(Routes.transaction_path(conn, :get, "NOPE", "also no"), %{"also" => "NOPE"})

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "incorrect id is not found", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_multiple_2:")}")
        |> get(
          Routes.transaction_path(
            conn,
            :get,
            "test_acc_GEZDGNBVGY3TQOJR",
            "test_txn_GIYDINRZGQZTAMBQ"
          ),
          %{
            "account_id" => "test_acc_GEZDGNBVGY3TQOJR",
            "transaction_id" => "nope"
          }
        )

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "We get the transaction returned", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)

      response =
        build_conn()
        |> put_req_header(
          "authorization",
          "Basic #{Base.url_encode64("test_multiple_1234567891:")}"
        )
        |> get(
          Routes.transaction_path(
            conn,
            :get,
            "test_acc_GEZDGNBVGY3TQOJR",
            "test_txn_GIYDINRZGQZTAMBQ"
          ),
          %{
            "account_id" => "test_acc_GEZDGNBVGY3TQOJR",
            "transaction_id" => "test_txn_GIYDINRZGQZTAMBQ"
          }
        )
        |> json_response(200)

      assert response == %{
               "account_id" => "test_acc_GEZDGNBVGY3TQOJR",
               "amount" => "-712.64",
               "date" => "2020-11-01",
               "description" => "Wendy's",
               "id" => "test_txn_GIYDINRZGQZTAMBQ",
               "links" => %{
                 "account" => "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR",
                 "self" =>
                   "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR/transactions/test_txn_GIYDINRZGQZTAMBQ"
               },
               "running_balance" => "10712.64",
               "type" => "card_payment"
             }
    end
  end
end
