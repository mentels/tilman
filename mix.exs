defmodule TilManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :til_manager,
      version: "1.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [
        main_module: TilManager.CLI,
        name: :tilman,
        path: "tilman"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:til,
       git: "git@github.com:mentels/TIL.git",
       runtime: false,
       only: :dev,
       # will work ONLY if there's a need to compile it
       compile: "cd ./../../ && ln -s ./deps/til ./",
       app: false},
       {:slugger, "~> 0.3.0"}
    ]
  end
end
