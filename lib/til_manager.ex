defmodule TilManager do
  @moduledoc """
  Documentation for TilManager.
  """
  @readme_file "README.md"
  @commit_file "commit_msg.txt"

  alias TilManager.Entry

  require Logger

  ### API

  def add_entry(entry, til_base_dir) do
    til_base_dir
    |> read_readme()
    |> update_readme(entry)
    |> write_file(@readme_file, til_base_dir)

    write_file(entry.content, entry.path, til_base_dir)
  end

  def update_entries_count(entry_regex, til_base_dir) do
    entries_count = count_entries(entry_regex, til_base_dir)

    til_base_dir
    |> read_readme()
    |> update_readme(entries_count)
    |> write_file(@readme_file, til_base_dir)

    entries_count
  end

  def write_commit_message(entry, til_base_dir) do
    entry
    |> commit_message()
    |> write_file(@commit_file, til_base_dir)

    @commit_file
  end

  ### HELPERS

  defp read_readme(til_base_dir) do
    til_base_dir
    |> Path.join(@readme_file)
    |> File.read!()
  end

  defp update_readme(readme, %Entry{} = entry) do
    [before, category, rest] =
      String.split(readme, ~r/#+ #{entry.category}\n*/i, include_captures: true)

    before <> category <> to_string(entry) <> "\n" <> rest
  end

  defp update_readme(readme, entries_count) when is_integer(entries_count) do
    [before, match, rest] = String.split(readme, ~r/\d+ TIL.*/, include_captures: true)

    {old_entries_count, match_rest} = Integer.parse(match)

    Logger.debug(
      "Replacing old_entries_count=#{old_entries_count} with entries_count=#{entries_count}"
    )

    before <> :erlang.integer_to_binary(entries_count) <> match_rest <> "\n" <> rest
  end

  defp count_entries(entry_regex, til_base_dir) do
    readme = read_readme(til_base_dir)

    entry_regex
    |> Regex.scan(readme, capture: :first)
    |> length
  end

  defp commit_message(entry) do
    "[#{entry.category}]: #{entry.title}"
  end

  defp write_file(content, file, til_base_dir) do
    til_base_dir
    |> Path.join(file)
    |> File.write!(content)
  end
end
