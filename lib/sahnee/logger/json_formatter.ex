defmodule Sahnee.Logger.JsonFormatter do
  @moduledoc """
  Formatter for sahnee logs. Used to generate machine readable output.
  """

  def format(level, message, timestamp, metadata) do
    # Read opts
    {module, metadata} = Keyword.pop(metadata, :module)
    {function, metadata} = Keyword.pop(metadata, :function)
    {line, metadata} = Keyword.pop(metadata, :line)
    {pid, metadata} = Keyword.pop(metadata, :pid)
    {file, metadata} = Keyword.pop(metadata, :file)
    {application, metadata} = Keyword.pop(metadata, :application)
    {domain, metadata} = Keyword.pop(metadata, :domain)
    {registered_name, metadata} = Keyword.pop(metadata, :registered_name)

    # Format stuff
    {{year, month, day}, {hh, mm, ss, micro}} = timestamp

    json_lib().encode(%{
      level: level,
      time: %{
        year: year,
        month: month,
        day: day,
        hour: hh,
        minute: mm,
        second: ss,
        micro: micro
      },
      # TODO: Json serialize meta data aswell. Keep in mind that meta data must not be a valid JSON term.
      meta: inspect(metadata),
      message: message,
      call: %{
        domain: domain,
        file: file,
        application: application,
        name: registered_name,
        pid: pid,
        module: module,
        function: function,
        line: line
      }
    })
  end

  defp json_lib(), do: Application.get_env(:sahnee_logger, :json_library, Jason)
end
