defmodule CrmWeb.DealLive.Show do
  use CrmWeb, :live_view

  alias Crm.Deals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _uri, socket) do
    deal = Crm.Deals.get_deal!(id)
    client = Crm.Clients.get_client!(deal.client_id)
    sony_accounts = Crm.SonyAccounts.list_sony_accounts_by_client_id!(client.id)
    transactions = Crm.Transactions.list_transactions_by_deal_id(deal.id)

    card =
      case get_card_form_cache_by_deal(deal.id) do
        {:ok, nil} ->
          card = Crm.Cards.get_card_by_last_transaction()
          Crm.Cards.update_transaction_card(card, %{last_transaction: NaiveDateTime.utc_now()})
          put_card_in_cache!(deal.id, card)
          card

        {:ok, card} ->
          card
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:deal, deal)
     |> assign(:sony_accounts, sony_accounts)
     |> assign(:transactions, transactions)
     |> assign(:card, card)
     |> assign(:client, client)}
  end

  defp page_title(:show), do: "Show Deal"
  defp page_title(:edit, id), do: "Изменить #{id}"
  defp page_title(:edit), do: "Изменить Сделку"

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

  # @impl true
  # def handle_event("kill_card", %{"id" => id}, socket) do
  #   deal = Deals.get_deal!(id)
  #   {:ok, _} = Deals.delete_deal(deal)

  #   {:noreply, assign(socket, :deals, Crm.Deals.list_deals())}
  # end

  @impl true
  def handle_event("new_card", %{"id" => id}, socket) do
    Cachex.execute!(:my_cache, fn cache ->
      Cachex.del(:my_cache, "deal_#{id}")
    end)

    card = Crm.Cards.get_card_by_last_transaction()

    true = put_card_in_cache!(id, card)

    Crm.Cards.update_transaction_card(card, %{last_transaction: NaiveDateTime.utc_now()})

    {:noreply, assign(socket, :card, card)}
  end

  def get_card_by_transaction_id(transaction_id) do
    transaction = Crm.Transactions.get_transaction!(transaction_id)
    Crm.Cards.get_card!(transaction.card_id)
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/admin/deals/#{socket.assigns.deal.id}")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/live/deals")}
  end

  def get_card_form_cache_by_deal(deal_id) do
    Cachex.execute!(:my_cache, fn cache ->
      # set a base value in the cache
      # Cachex.put!(cache, deal_id, 20)
      # we're paused but other stuff can happen
      # this may have have been set elsewhere by this point
      Cachex.get(cache, "deal_#{deal_id}")
    end)
  end

  def put_card_in_cache!(deal_id, card) do
    Cachex.execute!(:my_cache, fn cache ->
      # set a base value in the cache
      Cachex.put!(cache, "deal_#{deal_id}", card)

      # we're paused but other stuff can happen
      # this may have have been set elsewhere by this point
      # Cachex.get(cache, "card_fro_deal_#{deal_id}")
    end)
  end
end
