defmodule Tastings.Bottle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bottles" do
    field :name, :string
    field :age, :integer
    field :blurb, :string
    field :distillery, :string
    field :proof, :integer
    field :tasting_id, :id
    field :presented, :boolean

    timestamps()
  end

  @doc false
  def changeset(bottles, attrs) do
    bottles
    |> cast(attrs, [:name, :distillery, :age, :proof, :blurb, :tasting_id, :presented])
    |> validate_required([:name])
    |> validate_required([:tasting_id])
    |> validate_number(:age, greater_than: 0, less_than: 100)
    |> validate_number(:proof, less_than: 200, greater_than: 65)
    |> validate_length(:blurb, max: 250)
    |> validate_length(:name, max: 40)
    |> validate_length(:distillery, max: 40)
  end
end
