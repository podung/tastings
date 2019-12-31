defmodule Tastings.Repo.Migrations.CreateTastings do
  use Ecto.Migration

  def change do
    create table(:tastings) do
      add :name, :string
      add :join_code, :string

      timestamps()
    end

  end
end
