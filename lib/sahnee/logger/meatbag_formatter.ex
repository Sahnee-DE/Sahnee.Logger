defmodule Sahnee.Logger.MeatbagFormatter do
  @moduledoc """
  Formatter for sahnee logs. Typically used for human readable output.
  """

  # Some metadata is not relevant for human consumtion.
  @ignored_meta [:file, :ansi_color, :mfa, :domain, :gl, :time, :erl_level]

  def format(level, message, timestamp, metadata) do
    # Read opts
    {application, metadata} = Keyword.pop(metadata, :application)
    {module, metadata} = Keyword.pop(metadata, :module)
    {function, metadata} = Keyword.pop(metadata, :function)
    {line, metadata} = Keyword.pop(metadata, :line)
    {pid, metadata} = Keyword.pop(metadata, :pid)
    {registered_name, metadata} = Keyword.pop(metadata, :registered_name)
    # Drop stuff we don't want displayed
    metadata = Keyword.drop(metadata, @ignored_meta)

    # Format stuff
    name = if registered_name, do: registered_name, else: pid
    {_, {hh, mm, ss, micro}} = timestamp
    module_str = module |> sanitize_module_name()
    level_str = String.pad_trailing("[#{level}]", 7)
    time_str = "#{pad_num(hh, 2)}:#{pad_num(mm, 2)}:#{pad_num(ss, 2)}-#{pad_num(micro, 3)}"
    meta_str = format_metadata(metadata)

    "[#{time_str}] #{level_str} " <>
      "[#{application} | #{inspect(name)}@#{module_str}.#{function}:#{line}] " <>
      "#{message}#{meta_str}\n"
  end

  def format_metadata([]), do: ""

  def format_metadata([{key, value} | next]) do
    # According to ducmentation metadata is always a keyword list
    # but the Logger.metadata does not actually guard against non-
    # atom keys, allowing metadata to esentially be a tuple list
    # with arbitrary keys.
    # https://hexdocs.pm/logger/Logger.html#t:metadata/0
    key_str =
      case key do
        key when is_atom(key) -> Atom.to_string(key)
        key when is_binary(key) -> key
        key -> inspect(key)
      end

    "\n    #{key_str}: #{inspect(value)}" <> format_metadata(next)
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
