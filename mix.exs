defmodule Generic.MixProject do
  use Mix.Project

  def project do
    [
      app: :building_blocks,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Building Blocks",
      source_url: "https://github.com/oliveiragahenrique/building_blocks",
      homepage_url: "https://oliveiragahenrique.github.io/building_blocks",
      docs: [
        # The main page in the docs
        main: "Generic",
        logo: "logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
