defmodule Tastings.Repo.Migrations.AddActiveBottleIdToTastings do
  use Ecto.Migration

  def change do
    alter table("tastings") do
      add :active_bottle_id, references(:bottles, on_delete: :nothing)
    end
  end
end
