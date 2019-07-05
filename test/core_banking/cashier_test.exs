defmodule CoreBanking.CashierTest do
  use ExSpec
  import Mock

  alias CoreBanking.Cashier

  @moduledoc "Unit Tests for Cashier"

  @valid_uuid "faf91031-bdb3-429b-96d0-2f7876ba263e"
  @invalid_uuid "0bc6a2ec-1195-4fd2-9f4a-bebecd883bc4"

  context "#operation" do
    it "should return error if the amount is not an integer" do
      assert Cashier.operation(:deposit, @valid_uuid, "not") == {:error, :invalid_amount}
    end

    it "should return error if the amount is not positive" do
      assert Cashier.operation(:deposit, @valid_uuid, -12) == {:error, :invalid_amount}
    end

    it "should return error if the operation is invalid" do
      assert Cashier.operation(:wtf, @valid_uuid, 12) == {:error, :invalid_operation}
    end

    it "should return error if the account doesn't exists" do
      with_mocks(registry_mocks()) do
        assert Cashier.operation(:deposit, @invalid_uuid, 12) == {:error, :not_found}
      end
    end

    it "should return the result of the operation" do
      with_mocks(cashier_mocks()) do
        assert Cashier.operation(:deposit, @valid_uuid, 12) == {:ok, 12_341_234}
      end
    end
  end

  def cashier_mocks do
    registry_mocks() ++ account_mocks()
  end

  def registry_mocks do
    [
      {CoreBanking.Registry, [],
       [
         exists: fn
           "faf91031-bdb3-429b-96d0-2f7876ba263e" -> :c.pid(0, 250, 0)
           "0bc6a2ec-1195-4fd2-9f4a-bebecd883bc4" -> nil
         end
       ]}
    ]
  end

  def account_mocks do
    [
      {CoreBanking.Account, [], [deposit: fn _uuid, _value -> {:ok, 12_341_234} end]}
    ]
  end
end
