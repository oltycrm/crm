defmodule Crm.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Crm.Repo

  alias Crm.Transactions.Transaction
  alias Crm.Cards

  @doc """
  Returns the list of transaction.

  ## Examples

      iex> list_transaction()
      [%Transaction{}, ...]

  """
  def list_transaction do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(%Crm.Deals.Deal{} = deal, %{"card_id" => card_id} = attrs \\ %{}) do
    Cards.update_transaction_card(Cards.get_card!(card_id), %{
      "last_transaction" => NaiveDateTime.utc_now()
    })

    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:deal, deal)
    |> Repo.insert()
  end

  # def create_transaction(%Crm.Deals.Deal{} = deal, %Crm.Cards.Card{} = card, attrs \\ %{}) do

  #   attrs = Map.put(attrs, "card_id", card.id)

  #   %Transaction{}
  #   |> Transaction.changeset(attrs)
  #   |> Ecto.Changeset.put_assoc(:deal, deal)
  #   |> Repo.insert()
  # end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def list_transactions_by_deal_id(deal_id) do
    Repo.all(
      from(
        t in Transaction,
        where: t.deal_id == ^deal_id
      )
    )
  end

  def list_transactions_by_card_id(card_id) do
    Repo.all(
      from(
        t in Transaction,
        where: t.card_id == ^card_id
      )
    )
  end

  def get_time_of_last_transaction(card_id) do
    case Repo.one(
           from(
             t in Transaction,
             order_by: [desc: t.inserted_at],
             where: t.card_id == ^card_id,
             limit: 1
           )
         ) do
      nil -> %Transaction{inserted_at: Date.new!(2000, 1, 1)}
      result -> result
    end
  end

  def number_of_transactions_by_card(card_id) do
    Repo.all(
      from t in Transaction,
        where: t.card_id == ^card_id,
        where: t.inserted_at >= ago(1, "day")
    )
  end
end
