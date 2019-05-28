defmodule CoreBanking.Account do
  use GenServer

  @moduledoc """
  Bank Account abstraction suitable for concurrent operations
  """

  ### GenServer API

  def init(initial_amount) do
    {:ok, initial_amount}
  end

  def handle_call(:balance, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:deposit, amount}, _from, state) do
    new_amount = amount + state
    {:reply, {:ok, new_amount}, new_amount}
  end

  def handle_call({:withdraw, amount}, _from, state) when state - amount < 0 do
    {:reply, {:error, :no_funds}, state}
  end

  def handle_call({:withdraw, amount}, _from, state) do
    new_amount = state - amount
    {:reply, {:ok, new_amount}, new_amount}
  end

  ### Client API / Helper functions

  def start_link(args) do
    GenServer.start_link(__MODULE__, Keyword.fetch!(args, :initial_amount),
      name: Keyword.fetch!(args, :uuid)
    )
  end

  @spec check_balance(atom()) :: {:ok, non_neg_integer()}
  def check_balance(account), do: GenServer.call(account, :balance)

  @spec deposit(atom(), non_neg_integer()) :: {:ok, non_neg_integer()}
  def deposit(account, value), do: GenServer.call(account, {:deposit, value})

  @spec withdraw(atom(), non_neg_integer()) :: {:ok, non_neg_integer()} | {:error, :no_funds}
  def withdraw(account, value), do: GenServer.call(account, {:withdraw, value})

  @spec process_name(pid()) :: atom()
  def process_name(pid), do: pid |> Process.info() |> Keyword.get(:registered_name)

  @spec exists(atom()) :: pid() | nil
  def exists(name), do: Process.whereis(name)
end
