defmodule CoreBankingTest do
  use ExUnit.Case

  alias CoreBanking

  @moduletag :capture_log

  doctest CoreBanking

  test "module exists" do
    assert is_list(CoreBanking.module_info())
  end
end
