defmodule Mix.Tasks.Pets.Seed do
  use Mix.Task

  @shortdoc "Seeds "
  @moduledoc """

  """

  def run(_args) do
    Mix.shell.info "Seeding pets -- starting application--"
    Mix.Task.run "app.start", []

    user = %{
      name: "lola"
    }

    Mongo.insert_one(:mongo, "pets", user)
  end
end