defmodule CrmWeb.CardController do
  use CrmWeb, :controller

  alias Crm.Cards
  alias Crm.Cards.Card

  def index(conn, _params) do
    cards = Cards.list_cards()
    # cards = Cards.list_cards_by_last_transaction()

    render(conn, "index.html", cards: cards)
  end

  def dead(conn, _params) do
    cards = Cards.list_cards()
    render(conn, "dead.html", cards: cards)
  end

  def new(conn, _params) do
    changeset = Cards.change_card(%Card{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"card" => card_params}) do
    case Cards.create_card(card_params) do
      {:ok, card} ->
        conn
        |> put_flash(:info, "Card created successfully.")
        |> redirect(to: Routes.card_path(conn, :show, card))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    card = Cards.get_card!(id)
    transactions = Crm.Transactions.list_transactions_by_card_id(card.id)
    render(conn, "show.html", card: card, transactions: transactions)
  end

  def edit(conn, %{"id" => id}) do
    card = Cards.get_card!(id)
    changeset = Cards.change_card(card)
    render(conn, "edit.html", card: card, changeset: changeset)
  end

  def update(conn, %{"id" => id, "card" => card_params}) do
    card = Cards.get_card!(id)

    case Cards.update_card(card, card_params) do
      {:ok, card} ->
        conn
        |> put_flash(:info, "Card updated successfully.")
        |> redirect(to: Routes.card_path(conn, :show, card))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", card: card, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    card = Cards.get_card!(id)
    {:ok, _card} = Cards.delete_card(card)

    conn
    |> put_flash(:info, "Card deleted successfully.")
    |> redirect(to: Routes.card_path(conn, :index))
  end
end
