defmodule Tastings.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Tastings.Repo
  alias Ecto.Multi

  alias Tastings.Events.Tasting

  # TODO: move this or structure this stuff better
  alias Tastings.Bottle

  @doc """
  Returns the list of tastings.

  ## Examples

      iex> list_tastings()
      [%Tasting{}, ...]

  """
  def list_tastings do
    Repo.all(Tasting)
  end

  @doc """
  Gets a single tasting.

  Raises `Ecto.NoResultsError` if the Tasting does not exist.

  ## Examples

      iex> get_tasting!(123)
      %Tasting{}

      iex> get_tasting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tasting!(id), do: Repo.get!(Tasting, id)

  @doc """
  Creates a tasting.

  ## Examples

      iex> create_tasting(%{field: value})
      {:ok, %Tasting{}}

      iex> create_tasting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tasting(attrs \\ %{}) do
    %Tasting{}
    |> Tasting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tasting.

  ## Examples

      iex> update_tasting(tasting, %{field: new_value})
      {:ok, %Tasting{}}

      iex> update_tasting(tasting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tasting(%Tasting{} = tasting, attrs) do
    tasting
    |> Tasting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tasting.

  ## Examples

      iex> delete_tasting(tasting)
      {:ok, %Tasting{}}

      iex> delete_tasting(tasting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tasting(%Tasting{} = tasting) do
    Repo.delete(tasting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tasting changes.

  ## Examples

      iex> change_tasting(tasting)
      %Ecto.Changeset{source: %Tasting{}}

  """
  def change_tasting(%Tasting{} = tasting) do
    Tasting.changeset(tasting, %{})
  end

  def get_by_code(join_code), do: Repo.get_by!(Tasting, join_code: join_code)

  def change_bottle(%Bottle{} = bottle, attrs \\ %{}) do
    Bottle.changeset(bottle, attrs)
  end

  def create_bottle(attrs \\ %{}) do
    %Bottle{}
    |> Bottle.changeset(attrs)
    |> Repo.insert()
  end

  def load_bottles_for_tasting(tasting) do
    tasting
    |> Repo.preload(:bottles)
  end

  def taste_bottle(%Bottle{} = bottle) do
    tasting = get_tasting!(bottle.tasting_id)

    Multi.new()
    |> Multi.update(:bottle, Bottle.changeset(bottle, %{ presented: true })) #TODO: question?  Does this only try to set the presented value, or try to set all the values?
    |> Multi.update(:tasting, Tasting.changeset(tasting, %{ active_bottle_id: bottle.id }))
    |> Repo.transaction
  end
end
