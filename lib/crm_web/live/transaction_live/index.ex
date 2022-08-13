defmodule CrmWeb.TransactionLive.Index do
  use CrmWeb, :live_view

  alias Crm.Transactions
  alias Crm.Transactions.Transaction

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :transaction_collection, list_transaction())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:transaction, Transactions.get_transaction!(id))
  end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Transaction")
  #   |> assign(:transaction, %Transaction{})
  # end

  defp apply_action(socket, :new, %{"deal_id" => deal_id, "card_id" => card_id}) do
    deal = Crm.Deals.get_deal!(deal_id)

    card = Crm.Cards.get_card!(card_id)
    # IO.inspect card, label: "card_shit"

    socket
    |> assign(:page_title, card.name)
    |> assign(:card_id, card.id)
    |> assign(:transaction, %Transaction{card_id: card.id})
    |> assign(:deal_2, card)
    |> assign(:deal, deal)
    |> assign(:pussy, "pussy")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transaction")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)

    {:noreply, assign(socket, :transaction_collection, list_transaction())}
  end

  defp list_transaction do
    Transactions.list_transaction()
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/admin/deals/")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/live/deals")}
  end
end
