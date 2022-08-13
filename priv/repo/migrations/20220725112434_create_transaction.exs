defmodule Crm.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transaction) do
      add(:amount, :float)
      add(:deal_id, references(:deals, on_delete: :nothing))
      add(:user_id, references(:users, on_delete: :nothing))
      add(:card_id, references(:cards, on_delete: :nothing))

      timestamps()
    end

    create(index(:transaction, [:deal_id]))
    create(index(:transaction, [:user_id]))
    create(index(:transaction, [:card_id]))
  end
end
