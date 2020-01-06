defmodule Tastings.Repo.Migrations.CreateBottles do
  use Ecto.Migration

  def change do
    create table(:bottles) do
      add :name, :string, null: false
      add :distillery, :string
      add :age, :integer
      add :proof, :integer
      add :blurb, :string
      add :tasting_id, references(:tastings, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:bottles, [:tasting_id])
    create index("users", [:name], unique: true)
  end
end
