defmodule Sahnee.Logger.MeatbagFormatter do
  @moduledoc """
  Formatter for sahnee logs. Typically used for human readable output.
  """

  def format(level, message, timestamp, metadata) do
    # Read opts
    {module, metadata} = Keyword.pop(metadata, :module)
    {function, metadata} = Keyword.pop(metadata, :function)
    {line, metadata} = Keyword.pop(metadata, :line)
    {pid, metadata} = Keyword.pop(metadata, :pid)
    {registered_name, metadata} = Keyword.pop(metadata, :registered_name)
    # Drop stuff we don't want displayed
    metadata =
      Keyword.drop(metadata, [:file, :application, :ansi_color, :mfa, :domain, :gl, :time])

    # Format stuff
    name = if registered_name, do: registered_name, else: pid
    {_, {hh, mm, ss, micro}} = timestamp
    module_str = module |> sanitize_module_name()
    level_str = String.pad_trailing("[#{level}]", 7)
    time_str = "#{pad_num(hh, 2)}:#{pad_num(mm, 2)}:#{pad_num(ss, 2)}-#{pad_num(micro, 3)}"

    meta_str =
      if metadata !== [] do
        "\n #{inspect(metadata)}"
      else
        ""
      end

    "[#{time_str}] #{level_str} " <>
      "[#{inspect(name)}@#{module_str}.#{function}:#{line}] " <>
      "#{message}#{meta_str}\n"
  end

  defp sanitize_module_name(module) do
    module
    |> to_string()
    |> String.replace_prefix("Elixir.", "")
  end

  defp pad_num(num, dig) do
    num
    |> to_string()
    |> String.pad_leading(dig, "0")
  end
end
