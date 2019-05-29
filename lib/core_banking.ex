defmodule CoreBanking do
  @moduledoc """
  Documentation for CoreBanking.
  """

  def list_all_accounts do
    accounts =
      CoreBanking.AccountRegistry
      |> DynamicSupervisor.which_children()
      |> Enum.map(&map_to_process_name/1)

    {:ok, accounts}
  end

  def get_balance_from_account(uuid) do
    case CoreBanking.Account.exists(uuid) do
      nil -> {:error, :not_found}
      _pid -> CoreBanking.Account.check_balance(uuid)
    end
  end

  def operation(operation, _uuid, _amount) when operation not in [:deposit, :withdrawal],
    do: {:error, :invalid_operation}

  def operation(_operation, _uuid, amount) when not is_integer(amount),
    do: {:error, :invalid_amount}

  def operation(_operation, _uuid, amount) when not is_integer(amount),
    do: {:error, :invalid_amount}

  def operation(_operation, _uuid, amount) when 0 >= amount, do: {:error, :invalid_amount}
  def operation(:deposit, uuid, amount), do: make_deposit(uuid, amount)
  def operation(:withdrawal, uuid, amount), do: make_withdrawal(uuid, amount)

  def make_deposit(uuid, amount) do
    case CoreBanking.Account.exists(uuid) do
      nil -> {:error, :not_found}
      _pid -> CoreBanking.Account.deposit(uuid, amount)
    end
  end

  def make_withdrawal(uuid, amount) do
    case CoreBanking.Account.exists(uuid) do
      nil -> {:error, :not_found}
      _pid -> CoreBanking.Account.withdraw(uuid, amount)
    end
  end

  def create_new_account, do: create_new_account(0)

  def create_new_account(initial_amount) when not is_integer(initial_amount),
    do: {:error, :invalid_amount}

  def create_new_account(initial_amount) do
    uuid = UUID.uuid4()

    {:ok, _pid} =
      DynamicSupervisor.start_child(
        CoreBanking.AccountRegistry,
        {CoreBanking.Account, [uuid: String.to_atom(uuid), initial_amount: initial_amount]}
      )

    {:ok, uuid}
  end

  defp map_to_process_name(child) do
    child
    |> Kernel.elem(1)
    |> CoreBanking.Account.process_name()
    |> Atom.to_string()
  end
end
