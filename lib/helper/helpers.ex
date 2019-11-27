defmodule Pets.Helpers do
  alias Ecto.Schema.Metadata

  @moduledoc """
    Helper to fix a map from mongodb and transform them into valid Struct
  """

  @doc """
    Convert a map into a Struct
  """

  def struct_from_map(a_map, as: a_struct) do
    # Find the keys within the map
    keys =
      Map.keys(a_struct)
      |> Enum.filter(fn x -> x != :__struct__ end)

    # Process map, checking for both string / atom keys
    processed_map =
      for key <- keys, into: %{} do
        value = Map.get(a_map, key) || Map.get(a_map, to_string(key))
        {key, value}
      end

    a_struct = Map.merge(a_struct, processed_map)
    a_struct
  end

  @doc """
    Normalize a map with missing fields and converto them to a Struct
  """

  def normalize(map, struct) do
    id = Map.get(map, "_id")

    map
    |> Map.put(:id, BSON.ObjectId.encode!(id))
    |> Map.delete("_id")
    |> struct_from_map(as: struct)
    |> Map.put(:__meta__, %Metadata{state: :loaded})
  end
end
