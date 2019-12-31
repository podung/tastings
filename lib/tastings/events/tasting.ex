defmodule Tastings.Events.Tasting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tastings" do
    field :join_code, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(tasting, attrs) do
    tasting
    |> cast(attrs, [:name, :join_code])
    |> validate_required([:name, :join_code])
  end
end
