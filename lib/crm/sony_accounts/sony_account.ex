defmodule Crm.SonyAccounts.SonyAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sony_accounts" do
    field :email, :string
    field :password, :string
    field :client_id, :id

    timestamps()
  end

  @doc false
  def changeset(sony_account, attrs) do
    sony_account
    |> cast(attrs, [:email, :password, :client_id])
    |> validate_required([:email, :password, :client_id])
  end
end
