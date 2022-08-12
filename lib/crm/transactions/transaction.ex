defmodule Crm.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  schema "transaction" do
    field :amount, :float
    belongs_to :deal, Crm.Deals.Deal
    belongs_to :user, Crm.Accounts.User
    field :card_id, :id
    field :result, Ecto.Enum, values: [:Успех, :"Не Оплата", :"Не Привязка"]

    # belongs_to :card, Crm.Cards.Card

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :card_id, :result])
    |> validate_required([:card_id, :result])
    |> validate_success_amount_not_empty()
  end

  defp validate_success_amount_not_empty(transaction) do
    Logger.info(shit: transaction)

    case %Ecto.Changeset{changes: changes} = transaction do
      %{result: result} ->
        IO.inspect(result, label: "shit_result")
        Logger.info(shit_result: result)

      %{} ->
        nil
    end

    transaction
  end
end
