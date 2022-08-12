defmodule Crm.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :closed_date, :naive_datetime
    field :closed_status, Ecto.Enum, values: [:success, :dealy, :canceled]
    field :status, Ecto.Enum, values: [:new, :in_work, :closed]
    field :description, :string
    field :due_date, :naive_datetime
    field :name, :string
    field :deal, :id
    field :manager, :id
    field :client, :id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :due_date, :closed_date, :closed_status, :status])
    |> validate_required([:name, :due_date, :status])
  end
end
