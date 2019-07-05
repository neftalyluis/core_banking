defmodule CoreBanking do
  @moduledoc """
  Documentation for CoreBanking.
  """

  alias CoreBanking.Cashier
  alias CoreBanking.Registry

  defdelegate list_all_accounts, to: Registry
  defdelegate create_new_account, to: Registry
  defdelegate create_new_account(balance), to: Registry
  defdelegate operation(operation, uuid, amount), to: Cashier
end
