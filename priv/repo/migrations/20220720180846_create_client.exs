defmodule Crm.Repo.Migrations.CreateClient do
  use Ecto.Migration

  def change do
    create table(:client) do
      add(:name, :string)
      add(:avito, :string)

      timestamps()
    end
  end
end
