defmodule Tastings.Repo.Migrations.AddPresentedFieldToBottles do
  use Ecto.Migration

  def change do
    alter table("bottles") do
      add :presented, :boolean, null: false, default: false
    end
  end
end
