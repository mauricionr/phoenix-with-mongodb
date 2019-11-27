defmodule Pets.Animal do
  @moduledoc """
  The Animal context.
  """

  alias Pets.Animal.Pet

  @collection "pets"

  @doc """
  Returns the list of pets.

  ## Examples

      iex> list_pets()
      [%Pet{}, ...]

  """
  def list_pets(attrs \\ %{}) do
    Mongo.find(:mongo, @collection, Map.merge(%{}, attrs))
    |> Enum.to_list()
    |> Enum.map(fn pet -> Pets.Helpers.normalize(pet, %Pet{}) end)
  end

  @doc """
  Gets a single pet.

  Raises if the Pet does not exist.

  ## Examples

      iex> get_pet!(123)
      %Pet{}

  """
  def get_pet!(id, normalize \\ false) do
    pet = Mongo.find_one(:mongo, @collection, %{_id: BSON.ObjectId.decode!(id)})

    case normalize do
      true -> Pets.Helpers.normalize(pet, %Pet{})
      false -> pet
    end
  end

  @doc """
  Creates a pet.

  ## Examples

      iex> create_pet(%{field: value})
      {:ok, %Pet{}}

      iex> create_pet(%{field: bad_value})
      {:error, ...}

  """
  def create_pet(attrs \\ %{}) do
    changeset =
      %Pet{}
      |> Pet.changeset(attrs)

    Mongo.insert_one(:mongo, @collection, changeset.changes,
      return_document: :after,
      upsert: true
    )
  end

  @doc """
  Updates a pet.

  ## Examples

      iex> update_pet(pet, %{field: new_value})
      {:ok, %Pet{}}

      iex> update_pet(pet, %{field: bad_value})
      {:error, ...}

  """
  def update_pet(pet, attrs) do
    id = Map.get(pet, "_id")

    changeset =
      pet
      |> Pets.Helpers.normalize(%Pet{})
      |> Pet.changeset(attrs)

    case Enum.to_list(changeset.changes) do
      [] ->
        {:ok, pet}

      _ ->
        Mongo.find_one_and_update(
          :mongo,
          @collection,
          %{"_id" => id},
          %{"$set" => changeset.changes},
          return_document: :after
        )
    end
  end

  @doc """
  Deletes a Pet.

  ## Examples

      iex> delete_pet(pet)
      {:ok, %Pet{}}

      iex> delete_pet(pet)
      {:error, ...}

  """
  def delete_pet(pet) do
    Mongo.delete_one(:mongo, @collection, pet)
  end

  @doc """
  Returns a data structure for tracking pet changes.

  ## Examples

      iex> change_pet(pet)
      %Todo{...}

  """
  def change_pet(%Pet{} = pet) do
    pet
    |> Pet.changeset(%{})
  end
end
