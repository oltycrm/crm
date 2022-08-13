defmodule Crm.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :sender, references(:clients, on_delete: :nothing)
      add :messages, references(:messages, on_delete: :nothing)

      timestamps()
    end

    create index(:chats, [:sender])
    create index(:chats, [:messages])
  end
end
