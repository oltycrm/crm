defmodule Crm.Repo.Migrations.AddInUseToCards do
  use Ecto.Migration

  def change do
    alter table("cards") do
      add :in_use, :boolean
    end
  end
end
