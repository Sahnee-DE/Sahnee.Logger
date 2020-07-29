defmodule Sahnee.Logger do
  @moduledoc """
  Main module of the sahnee logger.
  """

  @doc """
  Creates a metadata block that sets metadata at the beginning of the block and clears it again after existing it.
  """
  defmacro metadata_block(metadata, do: expr) do
    nil_metadata = metadata |> Enum.map(fn {k, _v} -> {k, nil} end)

    quote do
      try do
        Logger.metadata(unquote(metadata))
        unquote(expr)
      after
        Logger.metadata(unquote(nil_metadata))
      end
    end
  end
end
