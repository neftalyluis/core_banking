defmodule CoreBanking.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias CoreBanking.Router

  @opts Router.init([])

  # Removes all child processes from the AccountRegistry supervisor
  # Useful for cleaning state on every test
  setup do
    CoreBanking.Registry.remove_all_accounts()
  end

  describe "#accounts" do
    test "that there are no accounts" do
      conn =
        :get
        |> conn("/accounts")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert Jason.decode!(conn.resp_body) == %{"accounts" => []}
    end

    test "that shows multiple accounts" do
      CoreBanking.create_new_account()
      CoreBanking.create_new_account()

      conn =
        :get
        |> conn("/accounts")
        |> Router.call(@opts)

      accounts = Jason.decode!(conn.resp_body)["accounts"]

      assert conn.state == :sent
      assert conn.status == 200
      assert length(accounts) == 2
    end

    test "that you can find an account" do
      {:ok, account_uuid} = CoreBanking.create_new_account()

      conn =
        :get
        |> conn("/accounts/#{account_uuid}")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
    end

    test "that you get 404 when searching for a non existent account" do
      uuid = UUID.uuid4()

      conn =
        :get
        |> conn("/accounts/#{uuid}")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 404
    end

    test "that you can create a new account" do
      conn =
        :post
        |> conn("/accounts/")
        |> Router.call(@opts)

      body = Jason.decode!(conn.resp_body)
      assert conn.state == :sent
      assert conn.status == 201
      assert body["account"]["uuid"]
    end

    test "that you can create a new account with a balance" do
      payload = %{balance: 12_345_678}

      conn =
        :post
        |> conn("/accounts/", payload)
        |> Router.call(@opts)

      body = Jason.decode!(conn.resp_body)
      assert conn.state == :sent
      assert conn.status == 201
      assert body["account"]["uuid"]
      assert body["account"]["balance"] == payload["balance"]
    end

    test "that you can't create a new account with an invalid balance" do
      payload = %{balance: "lol"}

      conn =
        :post
        |> conn("/accounts/", payload)
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
    end

    test "that you can deposit to an account" do
      {:ok, account_uuid} = CoreBanking.create_new_account()

      payload = %{operation: "deposit", amount: 12_341_234}

      conn =
        :put
        |> conn("/accounts/#{account_uuid}", payload)
        |> Router.call(@opts)

      body = Jason.decode!(conn.resp_body)
      assert conn.state == :sent
      assert conn.status == 200
      assert body["account"]["uuid"]
      assert body["account"]["balance"] == 12_341_234
    end

    test "that you can withdraw from an account" do
      {:ok, account_uuid} = CoreBanking.create_new_account(12_341_234)

      payload = %{operation: "withdraw", amount: 12_341_234}

      conn =
        :put
        |> conn("/accounts/#{account_uuid}", payload)
        |> Router.call(@opts)

      body = Jason.decode!(conn.resp_body)
      assert conn.state == :sent
      assert conn.status == 200
      assert body["account"]["uuid"]
      assert body["account"]["balance"] == 0
    end

    test "that you get 404 when making an operation for a non existent account" do
      uuid = UUID.uuid4()

      payload = %{operation: "withdraw", amount: 12_341_234}

      conn =
        :put
        |> conn("/accounts/#{uuid}", payload)
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 404
    end

    test "that you get 400 when making a bad request" do
      uuid = UUID.uuid4()

      payload = %{operation: "withdraw"}

      conn =
        :put
        |> conn("/accounts/#{uuid}", payload)
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
    end

    test "that you get 400 when using bad amounts" do
      {:ok, uuid} = CoreBanking.create_new_account()

      payload = %{operation: "withdraw", amount: "lol"}

      conn =
        :put
        |> conn("/accounts/#{uuid}", payload)
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
    end

    test "that you can't withdraw more money that you have on your account" do
      {:ok, account_uuid} = CoreBanking.create_new_account()

      payload = %{operation: "withdraw", amount: 12_341_234}

      conn =
        :put
        |> conn("/accounts/#{account_uuid}", payload)
        |> Router.call(@opts)

      body = Jason.decode!(conn.resp_body)
      assert conn.state == :sent
      assert conn.status == 409
      assert body["error"] == "no_funds"
    end
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/missing")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
