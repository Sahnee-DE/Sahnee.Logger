defmodule Sahnee.Logger.Test do
  use ExUnit.Case
  doctest Sahnee.Logger
  import Sahnee.Logger

  test "metadata block sets and clears metadata" do
    metadata_block value_1: 1, value_2: {:tuple, 2} do
      metadata = Logger.metadata()
      assert metadata[:value_1] === 1
      assert metadata[:value_2] === {:tuple, 2}
    end

    metadata_after = Logger.metadata()
    refute metadata_after[:value_1]
    refute metadata_after[:value_2]
  end
end
