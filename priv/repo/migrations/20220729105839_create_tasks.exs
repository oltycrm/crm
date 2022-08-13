defmodule Crm.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :text
      add :due_date, :naive_datetime
      add :closed_date, :naive_datetime
      add :closed_status, :string
      add :status, :string
      add :deal, references(:deals, on_delete: :nothing)
      add :manager, references(:users, on_delete: :nothing)
      add :client, references(:clients, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:deal])
    create index(:tasks, [:manager])
    create index(:tasks, [:client])
  end
end
