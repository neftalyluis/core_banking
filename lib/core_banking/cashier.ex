defmodule CoreBanking.Cashier do
  @moduledoc false

  @operations ~w(deposit withdraw balance)a

  alias CoreBanking.Account
  alias CoreBanking.Registry

  def operation(_operation, _uuid, amount) when not is_integer(amount) and not is_nil(amount),
    do: {:error, :invalid_amount}

  def operation(_operation, _uuid, amount) when 0 >= amount and not is_nil(amount),
    do: {:error, :invalid_amount}

  def operation(operation, _uuid, _amount) when operation not in @operations,
    do: {:error, :invalid_operation}

  def operation(operation, uuid, amount) do
    case Registry.exists(uuid) do
      nil -> {:error, :not_found}
      _pid -> :erlang.apply(Account, operation, Enum.reject([uuid, amount], &is_nil/1))
    end
  end
end
