defmodule Crm.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add(:name, :string)
      add(:card_number, :string)
      add(:day, :integer)
      add(:month, :integer)
      add(:year, :integer)
      add(:code, :integer)
      add(:status, :string)
      add(:balance, :float)
      add(:type, :string)
      add(:bank, :string)
      add(:system, :string)
      add(:top, :boolean, default: false, null: false)

      timestamps()
    end
  end
end
