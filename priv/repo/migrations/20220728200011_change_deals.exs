defmodule Crm.Repo.Migrations.ChangeDeals do
  use Ecto.Migration

  def change do
    alter table("deals") do
      add(:rubles, :float)
      add(:closed_status, :string)
    end
  end
end
