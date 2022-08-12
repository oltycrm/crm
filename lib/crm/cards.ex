defmodule Crm.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias Crm.Repo

  alias Crm.Cards.Card

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(
      from(
        c in Card,
        order_by: [desc: c.updated_at]
      )
    )
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id), do: Repo.get!(Card, id)

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  def update_card_in_use(%Card{} = card, attrs, shit) do
    attrs = Map.put(attrs, "in_use", shit)

    card
    |> Card.in_use_changeset(attrs)
    |> Repo.update()
  end

  def update_transaction_card(%Card{} = card, attrs) do
    card
    |> Card.last_transaction_changeset(attrs)
    |> Repo.update()
  end

  #   def update_transaction_card(card_id) do

  #     Repo.get_by(Card, id: card_id)
  #     |> Repo.(%{last_transaction: NaiveDateTime.utc_now()})
  # |> Repo.update()
  #   end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{data: %Card{}}

  """
  def change_card(%Card{} = card, attrs \\ %{}) do
    Card.changeset(card, attrs)
  end

  def list_cards_by_status(status) do
    Repo.all(
      from c in Card,
        where: c.status == ^status
    )
  end

  def list_cards_by_statuses(list_of_statuses) do
    Repo.all(
      from c in Card,
        where: c.status in ^list_of_statuses
    )
  end

  def get_card_by_last_transaction do
    #     select B.* from tableB B
    # left join tableA A
    #   on B.id = A.id and B.type = A.type
    # where B.isActive = 1
    #   and A.id is null
    # order by B.id, B.type
    Repo.one(
      from(
        c in Card,
        order_by: [asc: c.last_transaction],
        limit: 1
      )
    )
  end
end
