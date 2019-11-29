defmodule TilManager.CLI do
  alias TilManager.Entry

  require Logger

  @required_opts [:category, :title]

  def main(args) do
    {category, title, content} = parsed = parse_script_args(args)
    til_base_dir = til_base_dir()

    maybe_print_debug_info(parsed)

    entry = Entry.new(category, title, content)
    TilManager.add_entry(entry, til_base_dir)
    Logger.info("Added entry into category=#{entry.category} with title=#{entry.title}")

    new_count = TilManager.update_entries_count(Entry.regex(), til_base_dir)
    Logger.info("Updated entries count to new_count=#{new_count}")

    commit_path = TilManager.write_commit_message(entry, til_base_dir)
    Logger.info("Written commit message to file=#{commit_path}")

    prompt_user_action(entry.path, commit_path, til_base_dir)
  end

  defp til_base_dir() do
    System.get_env("TIL_PATH") || Application.get_env(:til_manager, :base_dir, ".")
  end

  defp parse_script_args(args) do
    case OptionParser.parse(args,
           strict: [category: :string, title: :string, debug: :boolean, version: :boolean],
           aliases: [c: :category, t: :title, v: :version]
         ) do
      {parsed, args, []} when length(args) <= 1 ->
        maybe_debug_loglevel(parsed[:debug])
        maybe_print_version_and_halt(parsed[:version])
        assert_required_opts_present(parsed)
        {parsed[:category], parsed[:title], parse_content(args)}

      {_, invalid_args, []} ->
        invalid_usage_halt("Invalid arguments: #{inspect(invalid_args)}", 1)

      {_, _, invalid_opts} ->
        invalid_usage_halt("Invalid options: #{inspect(invalid_opts)}", 2)
    end
  end

  defp parse_content([content]), do: content
  defp parse_content([]), do: ""

  defp maybe_debug_loglevel(debug?), do: debug? && Logger.configure(level: :debug)

  defp maybe_print_version_and_halt(nil), do: nil
  defp maybe_print_version_and_halt(_) do
    {:ok, vsn} = :application.get_key(:til_manager, :vsn)
    IO.puts("#{vsn}")
    System.halt()
  end

  defp assert_required_opts_present(opts) do
    Enum.all?(@required_opts, &Keyword.has_key?(opts, &1)) ||
      invalid_usage_halt("Missing required argument", 3)
  end

  defp invalid_usage_halt(message, exit_code) do
    Logger.error("Halting: " <> message)
    IO.puts(usage())
    System.halt(exit_code)
  end

  defp usage() do
    """
    Usage:
       #{script_name()} --category|-c CATEGORY --title|-t TITLE [CONTENT] [--debug]
       #{script_name()} -v|--version

    Example:
       #{script_name()} -c elixir -t  "How to get an escript name?" "Call `:escript.script_name()`"
    """
  end

  defp script_name(), do: :escript.script_name() |> to_string()

  defp maybe_print_debug_info({category, title, content}) do
    Logger.debug("base_dir=#{til_base_dir()}")
    Logger.debug("parsed category=#{category} title=#{title} content=#{content}")
    Logger.debug("log_level=#{Logger.level()}")
  end

  defp prompt_user_action(entry_path, commit_path, til_base_dir) do
    entry_absolute_path = Path.join(til_base_dir, entry_path)
    commit_absolute_path = Path.join(til_base_dir, commit_path)

    IO.puts("""
    ============================================================================
    TIL created, to finsih do the following:

      1. Fill in the #{entry_absolute_path} if needed
      2. Commit the TIL with git commit -eF #{commit_absolute_path}
    ============================================================================
    """)
  end
end
