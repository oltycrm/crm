defmodule Crm.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:name, :string)
      add(:period, :integer)
      add(:price, :float)

      timestamps()
    end
  end
end
