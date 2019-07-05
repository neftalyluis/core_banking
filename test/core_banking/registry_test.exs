defmodule CoreBanking.RegistryTest do
  use ExSpec

  alias CoreBanking.Account
  alias CoreBanking.Registry

  @moduledoc "Unit Tests for the Registry"

  setup do
    Registry.remove_all_accounts()
  end

  context "#create_new_account" do
    it "creates an account with the default balance" do
      assert {:ok, uuid} = Registry.create_new_account()
      assert Account.balance(String.to_atom(uuid)) == {:ok, 0}
    end

    it "creates an account with a given balance" do
      amount = 1234
      assert {:ok, uuid} = Registry.create_new_account(amount)
      assert Account.balance(String.to_atom(uuid)) == {:ok, amount}
    end

    it "returns an error with a bad balance" do
      assert Registry.create_new_account("memes") == {:error, :invalid_amount}
    end
  end

  context "#list_all_accounts" do
    it "shows no accounts" do
      assert Registry.list_all_accounts() == {:ok, []}
    end

    it "shows one account" do
      {:ok, uuid} = Registry.create_new_account()
      assert Registry.list_all_accounts() == {:ok, [uuid]}
    end
  end

  context "#remove_all_accounts" do
    it "removes all the accounts created" do
      Registry.create_new_account()
      Registry.create_new_account()

      Registry.remove_all_accounts()

      assert Registry.list_all_accounts() == {:ok, []}
    end
  end

  context "#exists" do
    it "returns a PID if the process exists" do
      {:ok, uuid} = Registry.create_new_account()

      assert Registry.exists(String.to_atom(uuid))
    end

    it "returns nil if the process doesn't exists" do
      uuid = UUID.uuid4() |> String.to_atom()

      assert is_nil(Registry.exists(uuid))
    end
  end
end
