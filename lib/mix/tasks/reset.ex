defmodule Mix.Tasks.Pets.Reset do
  use Mix.Task

  @shortdoc "Resets all data in database"

  @moduledoc """
    There might be a better way to do this!

    You have to list all your collections listed.
  """

  def run(_args) do
    Mix.Task.run("app.start", [])
    Mix.shell().info("Reset all data")
    Mongo.delete_many(:mongo, "pets", %{})
  end
end
