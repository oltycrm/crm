defmodule CrmWeb.ChatLive.Index do
  use CrmWeb, :live_view

  alias Crm.Chats
  alias Crm.Chats.Chat

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :chats, list_chats())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chat")
    |> assign(:chat, Chats.get_chat!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chat")
    |> assign(:chat, %Chat{})
  end

  defp apply_action(socket, :index, _params) do
    deal = Crm.Deals.get_deal!(1)
    client = Crm.Clients.get_client!(deal.client_id)
    sony_accounts = Crm.SonyAccounts.list_sony_accounts_by_client_id!(client.id)
    transactions = Crm.Transactions.list_transactions_by_deal_id(deal.id)

    socket
    |> assign(:page_title, "Listing Chats")
    |> assign(:chat, nil)
    |> assign(:deal, deal)
    |> assign(:sony_accounts, sony_accounts)
    |> assign(:transactions, transactions)
    |> assign(:client, client)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chat = Chats.get_chat!(id)
    {:ok, _} = Chats.delete_chat(chat)

    {:noreply, assign(socket, :chats, list_chats())}
  end

  defp list_chats do
    Chats.list_chats()
  end

  alias Crm.Deals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    deal = Crm.Deals.get_deal!(id)
    client = Crm.Clients.get_client!(deal.client_id)
    sony_accounts = Crm.SonyAccounts.list_sony_accounts_by_client_id!(client.id)
    transactions = Crm.Transactions.list_transactions_by_deal_id(deal.id)

    {:noreply,
     socket
     |> assign(:deal, deal)
     |> assign(:sony_accounts, sony_accounts)
     |> assign(:transactions, transactions)
     |> assign(:client, client)}
  end

  def get_client_name_by_deal_id(deal_id) do
    deal = Crm.Deals.get_deal!(deal_id)
    client = Crm.Clients.get_client!(deal.client_id)
    client.name
  end

  def handle_event("delete_transaction", %{"id" => id}, socket) do
    transaction = Crm.Transactions.get_transaction!(id)
    {:ok, _} = Crm.Transactions.delete_transaction(transaction)

    {:noreply, assign(socket, :transaction_collection, Crm.Transactions.list_transaction())}
  end

  @impl true
  def handle_event("delete_deal", %{"id" => id}, socket) do
    deal = Deals.get_deal!(id)
    {:ok, _} = Deals.delete_deal(deal)

    {:noreply, assign(socket, :deals, Crm.Deals.list_deals())}
  end

  def get_card_by_transaction_id(transaction_id) do
    transaction = Crm.Transactions.get_transaction!(transaction_id)
    Crm.Cards.get_card!(transaction.card_id)
  end
end
