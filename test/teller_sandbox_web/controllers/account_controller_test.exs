defmodule TellerSandboxWeb.AccountControllerTest do
  use TellerSandboxWeb.ConnCase, async: true

  describe "all" do
    test "We can query for all of the accounts when we are signed in", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1234567891:")}")
        |> get(Routes.account_path(conn, :all))
        |> json_response(200)

      assert response == %{
               "account_number" => 1_234_567_891,
               "balances" => %{"available" => 10, "ledger" => 10},
               "currency_code" => "USD",
               "enrollment_id" => "test_MTIzNDU2Nzg5MQ==",
               "id" => "test_acc_GEZDGNBVGY3TQOJR",
               "institution" => %{"id" => "citi", "name" => "Citi"},
               "links" => %{
                 "self" => "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR",
                 "transactions" =>
                   "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR/transactions"
               },
               "name" => "Ronald Reagan",
               "routing_numbers" => %{"ach" => 3_801_721_456, "wire" => 219_054_049}
             }
    end

    test "Querying for multiple accounts", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header(
          "authorization",
          "Basic #{Base.url_encode64("test_multiple_1234567891:")}"
        )
        |> get(Routes.account_path(conn, :all))
        |> json_response(200)

      assert response == [
               %{
                 "account_number" => 772_284_235,
                 "balances" => %{"available" => 10, "ledger" => 10},
                 "currency_code" => "USD",
                 "enrollment_id" => "test_NzcyMjg0MjM1",
                 "id" => "test_acc_G43TEMRYGQZDGNI=",
                 "institution" => %{"id" => "capital_one", "name" => "Capital One"},
                 "links" => %{
                   "self" => "http://localhost/accounts/test_acc_G43TEMRYGQZDGNI=",
                   "transactions" =>
                     "http://localhost/accounts/test_acc_G43TEMRYGQZDGNI=/transactions"
                 },
                 "name" => "Bill Clinton",
                 "routing_numbers" => %{"ach" => 1_317_588_895, "wire" => 2_011_391_163}
               },
               %{
                 "account_number" => 3_444_322_977,
                 "balances" => %{"available" => 10, "ledger" => 10},
                 "currency_code" => "USD",
                 "enrollment_id" => "test_MzQ0NDMyMjk3Nw==",
                 "id" => "test_acc_GM2DINBTGIZDSNZX",
                 "institution" => %{"id" => "wells_fargo", "name" => "Wells Fargo"},
                 "links" => %{
                   "self" => "http://localhost/accounts/test_acc_GM2DINBTGIZDSNZX",
                   "transactions" =>
                     "http://localhost/accounts/test_acc_GM2DINBTGIZDSNZX/transactions"
                 },
                 "name" => "Jimmy Carter",
                 "routing_numbers" => %{"ach" => 2_716_284_729, "wire" => 3_784_891_377}
               },
               %{
                 "account_number" => 2_863_746_943,
                 "balances" => %{"available" => 10, "ledger" => 10},
                 "currency_code" => "USD",
                 "enrollment_id" => "test_Mjg2Mzc0Njk0Mw==",
                 "id" => "test_acc_GI4DMMZXGQ3DSNBT",
                 "institution" => %{"id" => "bank_of_america", "name" => "Bank of America"},
                 "links" => %{
                   "self" => "http://localhost/accounts/test_acc_GI4DMMZXGQ3DSNBT",
                   "transactions" =>
                     "http://localhost/accounts/test_acc_GI4DMMZXGQ3DSNBT/transactions"
                 },
                 "name" => "George W. Bush",
                 "routing_numbers" => %{"ach" => 1_167_623_486, "wire" => 959_705_740}
               },
               %{
                 "account_number" => 1_234_567_891,
                 "balances" => %{"available" => 10, "ledger" => 10},
                 "currency_code" => "USD",
                 "enrollment_id" => "test_MTIzNDU2Nzg5MQ==",
                 "id" => "test_acc_GEZDGNBVGY3TQOJR",
                 "institution" => %{"id" => "citi", "name" => "Citi"},
                 "links" => %{
                   "self" => "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR",
                   "transactions" =>
                     "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR/transactions"
                 },
                 "name" => "Ronald Reagan",
                 "routing_numbers" => %{"ach" => 3_801_721_456, "wire" => 219_054_049}
               }
             ]
    end
  end

  describe "get" do
    test "querying for an id that doesn't exist 404s", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_2:")}")
        |> get(Routes.account_path(conn, :get, "not an id"), %{"account_id" => "not an id"})

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "querying for an id that doesn't exist 404s on multiple", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_multiple_2:")}")
        |> get(Routes.account_path(conn, :get, "not an id"), %{"account_id" => "not an id"})

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "querying for an id does exist returns that account", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1234567891:")}")
        |> get(Routes.account_path(conn, :get, "test_acc_GEZDGNBVGY3TQOJR"), %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJR"
        })
        |> json_response(200)

      assert response == %{
               "account_number" => 1_234_567_891,
               "balances" => %{"available" => 10, "ledger" => 10},
               "currency_code" => "USD",
               "enrollment_id" => "test_MTIzNDU2Nzg5MQ==",
               "id" => "test_acc_GEZDGNBVGY3TQOJR",
               "institution" => %{"id" => "citi", "name" => "Citi"},
               "links" => %{
                 "self" => "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR",
                 "transactions" =>
                   "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR/transactions"
               },
               "name" => "Ronald Reagan",
               "routing_numbers" => %{"ach" => 3_801_721_456, "wire" => 219_054_049}
             }
    end

    test "if there are multiple accounts we can find them", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header(
          "authorization",
          "Basic #{Base.url_encode64("test_multiple_1234567891:")}"
        )
        |> get(Routes.account_path(conn, :get, "test_acc_GEZDGNBVGY3TQOJR"), %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJR"
        })
        |> json_response(200)

      assert response == %{
               "account_number" => 1_234_567_891,
               "balances" => %{"available" => 10, "ledger" => 10},
               "currency_code" => "USD",
               "enrollment_id" => "test_MTIzNDU2Nzg5MQ==",
               "id" => "test_acc_GEZDGNBVGY3TQOJR",
               "institution" => %{"id" => "citi", "name" => "Citi"},
               "links" => %{
                 "self" => "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR",
                 "transactions" =>
                   "http://localhost/accounts/test_acc_GEZDGNBVGY3TQOJR/transactions"
               },
               "name" => "Ronald Reagan",
               "routing_numbers" => %{"ach" => 3_801_721_456, "wire" => 219_054_049}
             }
    end
  end
end
