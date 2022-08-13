defmodule Crm.Repo.Migrations.CreateDeals do
  use Ecto.Migration

  def change do
    create table(:deals) do
      add(:amount, :float)
      add(:status, :string)
      add(:client_id, references(:clients, on_delete: :nothing))
      add(:product_id, references(:products, on_delete: :nothing))
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:deals, [:client_id]))
    create(index(:deals, [:product_id]))
    create(index(:deals, [:user_id]))
  end
end
