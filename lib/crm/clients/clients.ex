defmodule Crm.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field :avito, :string
    field :name, :string
    field :phone, :string
    field :wa, :string
    field :tg, :string
    # has_many :sony_accounts, Crm.SonyAccounts.SonyAccount
    has_many :deals, Crm.Deals.Deal
    # has_many(:projects, Project, foreign_key: :employer_id)

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :avito, :phone, :wa, :tg])
    |> validate_required([:name, :phone])
  end
end
