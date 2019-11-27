defmodule TilManagerTest do
  use ExUnit.Case

  alias TilManager.Entry

  test "creates correct Til Entry" do
    ### GIVEN
    category = "Elixir"
    title = "How to use Ecto.Multi "
    content = "This is an example content.\nCan have multiple lines obviously.\n"

    ### WHEN
    te = Entry.new(category, title, content)

    ### THEN
    assert "elixir" = te.category
    # no white space at the end
    assert "How to use Ecto.Multi" = te.title
    assert "elixir/how-to-use-ecto-multi.md" = te.path
    # assert ^content = te.content
    assert """
           ## How to use Ecto.Multi

           This is an example content.
           Can have multiple lines obviously.
           """ = te.content
  end
end
