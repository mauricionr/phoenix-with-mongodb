defmodule Pets.Animal.Pet do
  @moduledoc """
  Pet schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Pets.Animal.Pet

  # the id maps to uuid
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
  end

  def changeset(%Pet{} = pet, params \\ %{}) do
    pet
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
