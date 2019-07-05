defmodule CoreBanking.Registry do
  @moduledoc "Methods for interacting with the Dynamic Supervisor handling the Bank Accounts"

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

  def list_all_accounts do
    accounts =
      CoreBanking.AccountRegistry
      |> DynamicSupervisor.which_children()
      |> Enum.map(&map_to_process_name/1)

    {:ok, accounts}
  end

  def remove_all_accounts do
    CoreBanking.AccountRegistry
    |> DynamicSupervisor.which_children()
    |> Enum.map(fn child -> Kernel.elem(child, 1) end)
    |> Enum.each(fn pid ->
      DynamicSupervisor.terminate_child(CoreBanking.AccountRegistry, pid)
    end)
  end

  @spec exists(String.t()) :: pid() | nil
  def exists(name), do: Process.whereis(name)

  defp map_to_process_name(child) do
    child
    |> Kernel.elem(1)
    |> process_name()
    |> Atom.to_string()
  end

  @spec process_name(pid()) :: atom()
  defp process_name(pid), do: pid |> Process.info() |> Keyword.get(:registered_name)
end
