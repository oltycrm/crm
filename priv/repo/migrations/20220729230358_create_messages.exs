defmodule Crm.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text
      add :sender_avito_url, :string

      timestamps()
    end
  end
end
