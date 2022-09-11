defmodule Crm.Deals.Deal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deals" do
    field :amount, :float
    field :status, Ecto.Enum, values: [:lead, :work, :closed]
    field :closed_status, Ecto.Enum, values: [:Успешно, :Ушел, :Кидала]
    field :rubles, :float

    # belongs_to :user, Rumbl.Accounts.User
    field :client_id, :id
    field :product_id, :id
    field :user_id, :id
    # belongs_to :user, Crm.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(deal, attrs) do
    deal
    |> cast(attrs, [
      :amount,
      :status, :product_id, :user_id, :client_id, :rubles, :closed_status])
    |> validate_required([
      :amount,
       :status, :product_id, :user_id])
  end
end
