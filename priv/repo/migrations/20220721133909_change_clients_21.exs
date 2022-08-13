defmodule Crm.Repo.Migrations.ChangeClients21 do
  use Ecto.Migration

  def change do
    alter table("client") do
      add(:phone, :string)
      add(:wa, :string, null: true)
      add(:tg, :string, null: true)
    end
  end
end
