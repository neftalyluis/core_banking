defmodule CoreBanking.AccountTest do
  use ExSpec

  alias CoreBanking.Account

  @moduledoc "Unit Tests for Account"

  setup do
    uuid = UUID.uuid4() |> String.to_atom()
    account = start_supervised!({Account, [uuid: uuid, initial_amount: 2000]})
    %{account: account}
  end

  context "#check_balance" do
    it "has a balance", %{account: account} do
      assert Account.balance(account) == {:ok, 2000}
    end
  end

  context "#deposit" do
    it "shows the new balance when making a deposit", %{account: account} do
      assert Account.deposit(account, 123) == {:ok, 2123}
    end
  end

  context "#withdraw" do
    it "shows the new balance when making a withdraw", %{account: account} do
      assert Account.withdraw(account, 1000) == {:ok, 1000}
    end

    it "shows an error when trying to withdraw more money", %{account: account} do
      assert Account.withdraw(account, 2001) == {:error, :no_funds}
    end
  end
end
