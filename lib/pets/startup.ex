defmodule Pets.Startup do
  @moduledoc """
    Module to statup all mongodb indexes
  """
  def ensure_indexes do
    Mongo.command(:mongo, %{
      createIndexes: "pets",
      indexes: [%{key: %{name: 1}, name: "name_idx", unique: false}]
    })
  end
end
