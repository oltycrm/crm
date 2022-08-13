defmodule Crm.Repo.Migrations.CreateSonyAccounts do
  use Ecto.Migration

  def change do
    create table(:sony_accounts) do
      add(:email, :string)
      add(:password, :string)
      add(:client_id, references(:clients, on_delete: :nothing))

      timestamps()
    end

    create(index(:sony_accounts, [:client_id]))
  end
end
