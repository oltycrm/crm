defmodule Crm.Repo.Migrations.AddNameAvatarToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:name, :string, null: true)
      add(:avatar_url, :string, null: true)
    end
  end
end
