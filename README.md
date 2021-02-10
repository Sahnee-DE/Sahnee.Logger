# Sahnee.Logger

The Sahnee.Logger application contains several helper modules to enable logging in a sahnee project.

- **Sahnee.Logger.metadata_block**: A macro that can be used to set logger metadata when entering a code block and automatically clear it after leaving it.
- **Sahnee.Logger.MeatbagFormatter**: A log formatter for better console output of log data optimized for human readability.
- **Sahnee.Logger.JsonFormatter**: A log formatter outputting JSON logs for optimial consuption by other services. No data is lost when creating JSON logs.

## Installation

The package can be installed by adding `sahnee_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sahnee_logger, git: "ssh://git@github.com:Sahnee-DE/Sahnee.Logger.git", tag: "<tag here>"}
  ]
end
```

Please make sure to replace `<tag here>` with the currently latest version/tag.

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).

## Tests

This project is unit tested. Use `mix test` to run unit tests.
