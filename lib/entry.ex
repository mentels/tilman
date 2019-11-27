defmodule TilManager.Entry do
  @moduledoc """
  Represents an entry to be added to the TIL's README.md

  Contains the cateogry, the title, the relative path the entry file is to be
  writtent to and optinally the content.
  """
  defstruct [:category, :title, :path, :content]

  @type t :: %__MODULE__{
          category: String.t(),
          title: String.t(),
          path: Path.t(),
          content: String.t()
        }

  ### API

  def new(category, title, content \\ "")
      when is_binary(category) and is_binary(title) and is_binary(content) do
    category = String.trim(category)
    title = String.trim(title)
    content = String.trim(content)

    %__MODULE__{
      category: category |> String.trim() |> String.downcase(),
      title: title,
      path: entry_relative_path(category, title),
      content: """
      ## #{title}

      #{content}
      """
    }
  end

  defimpl String.Chars  do
    def to_string(entry), do: "- [#{entry.title}](#{entry.path})"
  end

  @doc """
  Returns %Regex{} that matches an entry with `title` and `path` which are named
  subpatters in the regex.

  E.g. matches:
  '- [Generate chain of x590 v3 certificates](ssl_tls/generate_chain_of_x590_v3_certificates.md)'

  Can be used with e.g. with Regex.run/2.
  """
  def regex() do
    ~r/- (?<title>\[.*\])(?<path>\(.*\/.*\.md\))/
  end

  ### Helpers

  def entry_relative_path(category, title) do
    category = Slugger.slugify_downcase(category)
    filename = Slugger.slugify_downcase(title) <> ".md"
    Path.join(category, filename)
  end
end
