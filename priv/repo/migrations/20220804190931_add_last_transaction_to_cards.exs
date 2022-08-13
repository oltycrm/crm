defmodule Crm.Repo.Migrations.AddLastTransactionToCards do
  use Ecto.Migration

  def change do
    alter table("cards") do
      add :last_transaction, :naive_datetime
    end
  end
end
