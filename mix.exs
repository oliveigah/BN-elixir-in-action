defmodule ElixirInAction.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_in_action,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Elixir In Action",
      source_url: "https://github.com/oliveigah/BN-elixir-in-action",
      homepage_url: "https://techfromscratch.com.br/book-notes/elixir-in-action",
      docs: [
        # The main page in the docs
        main: "chapter_1",
        logo: "logo.png",
        extras: [
          "./lib/chapters/chapter_1/chapter_1.md",
          "./lib/chapters/chapter_2/chapter_2.md",
          "./lib/chapters/chapter_3/chapter_3.md",
          "./lib/chapters/chapter_4/chapter_4.md",
          "./lib/chapters/chapter_5/chapter_5.md",
          "./lib/chapters/chapter_6/chapter_6.md",
          "./lib/chapters/chapter_7/chapter_7.md",
          "./lib/chapters/chapter_8/chapter_8.md",
          "./lib/chapters/chapter_9/chapter_9.md",
          "./lib/chapters/chapter_10/chapter_10.md",
          "./lib/chapters/chapter_11/chapter_11.md",
          "./lib/chapters/chapter_12/chapter_12.md"
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
          ],
          "Chapter 9": [Chapter9.EchoServer],
          "Chapter 10": [
            Chapter10.QueryHelper,
            Chapter10.SimpleRegistry,
            Chapter10.EtsKeyValue,
            Chapter10.KeyValueStore,
            Chapter10.Bench
          ],
          "Todo List Project": [
            Todo.Application,
            Todo.Cache,
            Todo.Database,
            Todo.Entry,
            Todo.List,
            Todo.Metrics,
            Todo.ProcessRegistry,
            Todo.Server,
            Todo.System,
            Todo.Web,
            Database.Worker,
            Todo.List.CsvImporter
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Todo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:poolboy, "~> 1.5"},
      {:cowboy, "~> 2.8"},
      {:plug_cowboy, "~> 2.3"}
    ]
  end
end
