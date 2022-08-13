defmodule Crm.Repo.Migrations.RenameClients do
  use Ecto.Migration

  def change do
    rename(table("client"), to: table("clients"))
  end
end
