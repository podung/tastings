defmodule Tastings.Events.Tasting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tastings" do
    field :join_code, :string
    field :name, :string
    field :active_bottle_id, :integer

    has_many :bottles, Tastings.Bottle

    timestamps()
  end

  @doc false
  def changeset(tasting, attrs) do
    tasting
    |> cast(attrs, [:name, :join_code, :active_bottle_id])
    |> validate_required([:name, :join_code])
  end
end
