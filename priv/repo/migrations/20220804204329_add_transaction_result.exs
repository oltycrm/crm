defmodule Crm.Repo.Migrations.AddTransactionResult do
  use Ecto.Migration

  def change do
    alter table("transaction") do
      add :result, :string
    end
  end
end
