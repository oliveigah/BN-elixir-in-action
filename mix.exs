defmodule Generic.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_in_action,
      version: "0.0.6",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Elixir In Action",
      source_url: "https://github.com/oliveigah/elixir_in_action",
      homepage_url: "https://oliveigah.github.io/elixir_in_action",
      docs: [
        # The main page in the docs
        main: "chapter_1",
        logo: "logo.png",
        extras: [
          "./lib/chapter_1/chapter_1.md",
          "./lib/chapter_2/chapter_2.md",
          "./lib/chapter_3/chapter_3.md",
          "./lib/chapter_4/chapter_4.md",
          "./lib/chapter_5/chapter_5.md",
          "./lib/chapter_6/chapter_6.md"
        ],
        groups_for_modules: [
          "Chapter 2": [Chapter2.Calculator, Chapter2.Generic, Chapter2.Geometry],
          "Chapter 3": [
            Chapter3.CheckNumber,
            Chapter3.FileHelper,
            Chapter3.Geometry,
            Chapter3.ListHelper,
            Chapter3.MapHelper
          ],
          "Chapter 4": [Chapter4.Fraction],
          "Chapter 5": [Chapter5.QueryHelper, Chapter5.Calculator, Chapter5.DatabaseServer],
          "Chapter 6": [
            Chapter6.MyServerProcess,
            Chapter6.MyKeyValueStore,
            Chapter6.MyStackServer,
            Chapter6.KeyValueStore
          ]
        ]
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
